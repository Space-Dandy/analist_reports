using Microsoft.EntityFrameworkCore;
using reports_backend.Models;

namespace reports_backend.Data
{
  public class ApplicationDBContext : DbContext
  {
    public ApplicationDBContext(DbContextOptions<ApplicationDBContext> options) : base(options)
    { }

    public DbSet<User> Users { get; set; }
    public DbSet<Incident> Incidents { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    { }
  }
}