#nullable enable
using reports_backend.Models;

namespace reports_backend.DTOs
{
  public class CreateIncidentDto
  {
    public string FolioNumber { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public IncidentStatus Status { get; set; } = IncidentStatus.Pending;
    public string? ImagePath { get; set; }
  }
}
