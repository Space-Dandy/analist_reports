using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using reports_backend.DTOs;
using reports_backend.Models;
using reports_backend.Repositories;

namespace reports_backend.Controllers
{
  [ApiController]
  [Route("api/[controller]")]
  [Authorize]  // 🔒 All endpoints require JWT token
  public class IncidentsController : ControllerBase
  {
    private readonly IIncidentRepository _repository;

    public IncidentsController(IIncidentRepository repository)
    {
      _repository = repository;
    }

    // GET: api/incidents
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Incident>>> GetAll()
    {
      var incidents = await _repository.GetAllAsync();
      return Ok(incidents);
    }

    // GET: api/incidents/{id}
    [HttpGet("{id}")]
    public async Task<ActionResult<Incident>> GetById(int id)
    {
      var incident = await _repository.GetByIdAsync(id);

      if (incident == null)
        return NotFound();

      return Ok(incident);
    }

    // GET: api/incidents/my
    [HttpGet("my")]
    public async Task<ActionResult<IEnumerable<Incident>>> GetMyIncidents()
    {
      // Get userId from JWT token
      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

      if (userIdClaim == null)
        return Unauthorized();

      var userId = int.Parse(userIdClaim);
      var incidents = await _repository.GetByUserIdAsync(userId);

      return Ok(incidents);
    }

    // POST: api/incidents
    [HttpPost]
    public async Task<ActionResult<Incident>> Create([FromBody] CreateIncidentDto incidentDto)
    {
      // Get userId from JWT token
      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

      if (userIdClaim == null)
        return Unauthorized();

      var userId = int.Parse(userIdClaim);

      var incident = new Incident
      {
        UserId = userId,
        FolioNumber = incidentDto.FolioNumber,
        Title = incidentDto.Title,
        Description = incidentDto.Description,
        Status = incidentDto.Status,
        ImagePath = incidentDto.ImagePath,
        DateReported = DateTime.UtcNow
      };

      var created = await _repository.CreateAsync(incident);
      return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    // PUT: api/incidents/{id}
    [HttpPut("{id}")]
    public async Task<ActionResult<Incident>> Update(int id, [FromBody] CreateIncidentDto incidentDto)
    {
      var existing = await _repository.GetByIdAsync(id);
      if (existing == null)
        return NotFound();

      // Verify user owns this incident
      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
      if (userIdClaim == null || existing.UserId != int.Parse(userIdClaim))
        return Forbid();

      existing.FolioNumber = incidentDto.FolioNumber;
      existing.Title = incidentDto.Title;
      existing.Description = incidentDto.Description;
      existing.Status = incidentDto.Status;
      existing.ImagePath = incidentDto.ImagePath;

      var updated = await _repository.UpdateAsync(existing);
      return Ok(updated);
    }

    // DELETE: api/incidents/{id}
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
      var existing = await _repository.GetByIdAsync(id);
      if (existing == null)
        return NotFound();

      // Verify user owns this incident
      var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
      if (userIdClaim == null || existing.UserId != int.Parse(userIdClaim))
        return Forbid();

      await _repository.DeleteAsync(id);
      return NoContent();
    }
  }
}
