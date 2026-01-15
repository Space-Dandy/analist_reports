#nullable enable

using System.Collections.Generic;
using System.Threading.Tasks;
using reports_backend.Models;

namespace reports_backend.Repositories
{
  public interface IUserRepository
  {
    Task<IEnumerable<User>> GetAllAsync();
    Task<User?> GetByIdAsync(int id);
    Task<User> CreateAsync(User user);
    Task<User?> GetByEmailAsync(string email);

  }
}