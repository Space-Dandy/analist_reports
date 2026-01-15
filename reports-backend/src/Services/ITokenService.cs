using reports_backend.Models;

namespace reports_backend.Services
{
  public interface ITokenService
  {
    string GenerateToken(User user);
  }
}