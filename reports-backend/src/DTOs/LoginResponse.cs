using reports_backend.Models;

namespace reports_backend.DTOs
{
  public class LoginResponse
  {
    public string Token { get; set; }
    public User User { get; set; }
  }
}