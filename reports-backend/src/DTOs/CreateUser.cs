using reports_backend.Models;

namespace reports_backend.DTOs
{
  public class RegisterUserDto
  {
    public string Email { get; set; }
    public string Name { get; set; }
    public int Age { get; set; }
    public UserPosition Position { get; set; }
    public string Password { get; set; }
  }
}