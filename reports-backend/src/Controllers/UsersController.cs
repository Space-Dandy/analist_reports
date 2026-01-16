using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using reports_backend.Models;
using reports_backend.Repositories;
using reports_backend.DTOs;
using reports_backend.Services;
using BCrypt.Net;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace reports_backend.Controllers
{
  [ApiController]
  [Route("api/[controller]")]
  public class UsersController : ControllerBase
  {
    private readonly IUserRepository _repository;
    private readonly ITokenService _tokenService;

    public UsersController(IUserRepository repository, ITokenService tokenService)
    {
      _repository = repository;
      _tokenService = tokenService;
    }

    // GET: api/users/{id}
    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<User>>> GetById(int id)
    {
      var user = await _repository.GetByIdAsync(id);

      if (user == null)
        return NotFound(ApiResponse<User>.ErrorResponse("User not found."));

      return Ok(ApiResponse<User>.SuccessResponse(user, "User retrieved successfully."));
    }

    // POST: api/users
    [HttpPost]
    public async Task<ActionResult<ApiResponse<User>>> Create([FromBody] RegisterUserDto regiserDto)
    {
      var existingUser = await _repository.GetByEmailAsync(regiserDto.Email);
      if (existingUser != null)
      {
        return Conflict(ApiResponse<User>.ErrorResponse("Email is already registered."));
      }

      var user = new User
      {
        Email = regiserDto.Email,
        Name = regiserDto.Name,
        Age = regiserDto.Age,
        Position = regiserDto.Position,
        PasswordHash = BCrypt.Net.BCrypt.HashPassword(regiserDto.Password),
      };

      var created = await _repository.CreateAsync(user);
      var response = ApiResponse<User>.SuccessResponse(created, "User created successfully.");
      return CreatedAtAction(nameof(GetById), new { id = created.Id }, response);
    }

    [HttpPost("login")]

    //POST: api/users/login
    public async Task<ActionResult<ApiResponse<LoginResponse>>> Login([FromBody] LoginDto loginDto)
    {
      var user = await _repository.GetByEmailAsync(loginDto.Email);
      if (user == null || !BCrypt.Net.BCrypt.Verify(loginDto.Password, user.PasswordHash))
      {
        return Unauthorized(ApiResponse<LoginResponse>.ErrorResponse("Invalid email or password."));
      }

      //Generar token JWT
      var token = _tokenService.GenerateToken(user);

      var response = new LoginResponse
      {
        Token = token,
        User = user
      };

      return Ok(ApiResponse<LoginResponse>.SuccessResponse(response, "Login successful."));
    }

    // GET: api/users
    [HttpGet]
    [Authorize]
    public async Task<ActionResult<ApiResponse<IEnumerable<User>>>> GetAll()
    {
      var positionClaim = User.FindFirst("position")?.Value;
      if (positionClaim != ((int)UserPosition.Admin).ToString())
        return StatusCode(403, ApiResponse<string>.ErrorResponse("Only admins can access all users."));

      var users = await _repository.GetAllAsync();
      return Ok(ApiResponse<IEnumerable<User>>.SuccessResponse(users, "Users retrieved successfully."));
    }
  }
}