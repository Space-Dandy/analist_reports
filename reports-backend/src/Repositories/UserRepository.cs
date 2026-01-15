#nullable enable

using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using reports_backend.Data;
using reports_backend.Models;

namespace reports_backend.Repositories
{
  public class UserRepository : IUserRepository
  {
    private readonly ApplicationDBContext _context;

    public UserRepository(ApplicationDBContext context)
    {
      _context = context;
    }

    public async Task<IEnumerable<User>> GetAllAsync()
    {
      return await _context.Users.ToListAsync();
    }

    public async Task<User?> GetByIdAsync(int id)
    {
      return await _context.Users.FindAsync(id);
    }

    public async Task<User> CreateAsync(User user)
    {
      _context.Users.Add(user);
      await _context.SaveChangesAsync();
      return user;
    }

    public async Task<User?> GetByEmailAsync(string email)
    {
      return await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
    }
  }
}