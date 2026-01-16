#nullable enable

using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using reports_backend.DTOs;
using reports_backend.Models;
using reports_backend.Repositories;

namespace reports_backend.Controllers
{
  [ApiController]
  [Route("api/[controller]")]
  [Authorize]
  public class IncidentsController : ControllerBase
  {
    private readonly IIncidentRepository _repository;

    public IncidentsController(IIncidentRepository repository)
    {
      _repository = repository;
    }

    // GET: api/incidents
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Incident>>> GetAll([FromQuery] int? userId)
    {
      var positionClaim = User.FindFirst("position")?.Value;
      if (positionClaim != ((int)UserPosition.Admin).ToString())
        return StatusCode(403, ApiResponse<string>.ErrorResponse("Only admins can view all incidents."));

      IEnumerable<Incident> incidents;
      if (userId.HasValue)
      {
        incidents = await _repository.GetByUserIdAsync(userId.Value);
      }
      else
      {
        incidents = await _repository.GetAllAsync();
      }

      return Ok(ApiResponse<IEnumerable<Incident>>.SuccessResponse(incidents));
    }

    // GET: api/incidents/{id}
    [HttpGet("{id}")]
    public async Task<ActionResult<Incident>> GetById(int id)
    {
      var incident = await _repository.GetByIdAsync(id);

      if (incident == null)
        return NotFound(ApiResponse<string>.ErrorResponse("Incident not found."));

      return Ok(ApiResponse<Incident>.SuccessResponse(incident));
    }

    // GET: api/incidents/my
    [HttpGet("my")]
    public async Task<ActionResult<IEnumerable<Incident>>> GetMyIncidents()
    {
      // Get userId from JWT token
      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

      if (userIdClaim == null)
        return Unauthorized(ApiResponse<string>.ErrorResponse("Unauthorized"));

      var userId = int.Parse(userIdClaim);
      var incidents = await _repository.GetByUserIdAsync(userId);

      return Ok(ApiResponse<IEnumerable<Incident>>.SuccessResponse(incidents));
    }

    // POST: api/incidents
    [HttpPost]
    public async Task<ActionResult<Incident>> Create(
    [FromForm] string folioNumber,
    [FromForm] string title,
    [FromForm] string description,
    [FromForm] IncidentStatus status,
    [FromForm] IFormFile? imageFile)
    {
      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
      if (userIdClaim == null)
        return Unauthorized(ApiResponse<string>.ErrorResponse("Unauthorized"));

      var userId = int.Parse(userIdClaim);

      string? imagePath = null;
      if (imageFile != null && imageFile.Length > 0)
      {
        var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "src", "wwwroot", "images");
        if (!Directory.Exists(uploadsFolder))
          Directory.CreateDirectory(uploadsFolder);

        var fileName = Guid.NewGuid().ToString() + Path.GetExtension(imageFile.FileName);
        var filePath = Path.Combine(uploadsFolder, fileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
          await imageFile.CopyToAsync(stream);
        }

        imagePath = $"/images/{fileName}";
      }

      var userNameClaim = User.FindFirstValue(ClaimTypes.Name) ?? "";

      var incident = new Incident
      {
        UserId = userId,
        UserName = userNameClaim,
        FolioNumber = folioNumber,
        Title = title,
        Description = description,
        Status = status,
        ImagePath = imagePath,
        DateReported = DateTime.Now
      };

      var created = await _repository.CreateAsync(incident);
      return CreatedAtAction(nameof(GetById), new { id = created.Id }, ApiResponse<Incident>.SuccessResponse(created, "Incident created successfully."));
    }

    [HttpPost("{id}/authorize")]
    public async Task<IActionResult> AuthorizeIncident(int id, [FromBody] IncidentStatus status)
    {
      // Solo admins
      var positionClaim = User.FindFirst("position")?.Value;
      var isAdmin = positionClaim == ((int)UserPosition.Admin).ToString();
      if (!isAdmin) return Unauthorized(ApiResponse<string>.ErrorResponse("Unauthorized"));

      var incident = await _repository.GetByIdAsync(id);
      if (incident == null)
        return NotFound(ApiResponse<string>.ErrorResponse("Incident not found."));

      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
      var userNameClaim = User.FindFirst(ClaimTypes.Name)?.Value;
      if (userIdClaim == null)
        return Unauthorized(ApiResponse<string>.ErrorResponse("Unauthorized"));

      incident.AuthUserId = int.Parse(userIdClaim);
      incident.AuthUserName = userNameClaim ?? "";
      incident.ResolutionDate = DateTime.UtcNow;
      incident.Status = status;

      await _repository.UpdateAsync(incident);

      return Ok(ApiResponse<Incident>.SuccessResponse(incident, "Incident status updated."));
    }

    // PUT: api/incidents/{id}
    [HttpPut("{id}")]
    public async Task<ActionResult<Incident>> Update(int id, [FromBody] CreateIncidentDto incidentDto)
    {
      var existing = await _repository.GetByIdAsync(id);
      if (existing == null)
        return NotFound(ApiResponse<string>.ErrorResponse("Incident not found."));

      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
      if (userIdClaim == null || existing.UserId != int.Parse(userIdClaim))
        return StatusCode(403, ApiResponse<string>.ErrorResponse("Forbidden"));

      existing.FolioNumber = incidentDto.FolioNumber;
      existing.Title = incidentDto.Title;
      existing.Description = incidentDto.Description;
      existing.Status = incidentDto.Status;
      existing.ImagePath = incidentDto.ImagePath;

      var updated = await _repository.UpdateAsync(existing);
      return Ok(ApiResponse<Incident>.SuccessResponse(updated!, ""));
    }

    // DELETE: api/incidents/{id}
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
      var existing = await _repository.GetByIdAsync(id);
      if (existing == null)
        return NotFound(ApiResponse<string>.ErrorResponse("Incident not found."));

      // Verify user owns this incident
      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
      if (userIdClaim == null || existing.UserId != int.Parse(userIdClaim))
        return StatusCode(403, ApiResponse<string>.ErrorResponse("Forbidden"));

      await _repository.DeleteAsync(id);
      return Ok(ApiResponse<string>.SuccessResponse(null, "Incident deleted successfully."));
    }

    [HttpPost("upload-image")]
    [AllowAnonymous]
    public async Task<IActionResult> UploadImage(IFormFile file)
    {
      if (file == null || file.Length == 0)
        return BadRequest("No file uploaded.");

      var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");
      if (!Directory.Exists(uploadsFolder))
        Directory.CreateDirectory(uploadsFolder);

      var fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
      var filePath = Path.Combine(uploadsFolder, fileName);

      using (var stream = new FileStream(filePath, FileMode.Create))
      {
        await file.CopyToAsync(stream);
      }

      // Return the relative path to save in DB
      var relativePath = $"/images/{fileName}";
      return Ok(new { path = relativePath });
    }
  }
}
