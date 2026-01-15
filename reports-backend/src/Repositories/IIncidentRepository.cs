#nullable enable

using System.Collections.Generic;
using System.Threading.Tasks;
using reports_backend.Models;

namespace reports_backend.Repositories
{
  public interface IIncidentRepository
  {
    Task<IEnumerable<Incident>> GetAllAsync();
    Task<Incident?> GetByIdAsync(int id);
    Task<IEnumerable<Incident>> GetByUserIdAsync(int userId);
    Task<Incident> CreateAsync(Incident incident);
    Task<Incident?> UpdateAsync(Incident incident);
    Task<bool> DeleteAsync(int id);
  }
}
