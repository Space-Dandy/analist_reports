#nullable enable

using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using reports_backend.Data;
using reports_backend.Models;

namespace reports_backend.Repositories
{
  public class IncidentRepository : IIncidentRepository
  {
    private readonly ApplicationDBContext _context;

    public IncidentRepository(ApplicationDBContext context)
    {
      _context = context;
    }

    public async Task<IEnumerable<Incident>> GetAllAsync()
    {
      return await _context.Incidents.ToListAsync();
    }

    public async Task<Incident?> GetByIdAsync(int id)
    {
      return await _context.Incidents.FirstOrDefaultAsync(i => i.Id == id);
    }

    public async Task<IEnumerable<Incident>> GetByUserIdAsync(int userId)
    {
      return await _context.Incidents
        .Where(i => i.UserId == userId)
        .ToListAsync();
    }

    public async Task<Incident> CreateAsync(Incident incident)
    {
      _context.Incidents.Add(incident);
      await _context.SaveChangesAsync();
      return incident;
    }

    public async Task<Incident?> UpdateAsync(Incident incident)
    {
      var existing = await _context.Incidents.FindAsync(incident.Id);
      if (existing == null)
        return null;

      existing.FolioNumber = incident.FolioNumber;
      existing.Title = incident.Title;
      existing.Description = incident.Description;
      existing.Status = incident.Status;
      existing.ImagePath = incident.ImagePath;

      await _context.SaveChangesAsync();
      return existing;
    }

    public async Task<bool> DeleteAsync(int id)
    {
      var incident = await _context.Incidents.FindAsync(id);
      if (incident == null)
        return false;

      _context.Incidents.Remove(incident);
      await _context.SaveChangesAsync();
      return true;
    }
  }
}
