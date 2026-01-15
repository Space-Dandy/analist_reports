using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using reports_backend.Models;
using reports_backend.Repositories;
using reports_backend.DTOs;
using reports_backend.Services;
using BCrypt.Net;

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

    // GET: api/users
    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetAll()
    {
      var users = await _repository.GetAllAsync();
      return Ok(users);
    }

    // GET: api/users/{id}
    [HttpGet("{id}")]
    public async Task<ActionResult<User>> GetById(int id)
    {
      var user = await _repository.GetByIdAsync(id);

      if (user == null)
        return NotFound();

      return Ok(user);
    }

    // POST: api/users
    [HttpPost]
    public async Task<ActionResult<User>> Create([FromBody] RegisterUserDto regiserDto)
    {
      var user = new User
      {
        Email = regiserDto.Email,
        Name = regiserDto.Name,
        Age = regiserDto.Age,
        Position = regiserDto.Position,
        PasswordHash = BCrypt.Net.BCrypt.HashPassword(regiserDto.Password),
      };

      var created = await _repository.CreateAsync(user);
      return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPost("login")]

    //POST: api/users/login
    public async Task<ActionResult<LoginResponse>> Login([FromBody] LoginDto loginDto)
    {
      var user = await _repository.GetByEmailAsync(loginDto.Email);
      if (user == null || !BCrypt.Net.BCrypt.Verify(loginDto.Password, user.PasswordHash))
      {
        return Unauthorized("Invalid email or password.");
      }

      //Generar token JWT
      var token = _tokenService.GenerateToken(user);

      var response = new LoginResponse
      {
        Token = token,
        User = user
      };

      return Ok(response);
    }
  }
}