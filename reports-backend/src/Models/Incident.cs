#nullable enable
using System;
using reports_backend.Models;

namespace reports_backend.Models
{
  public enum IncidentStatus
  {
    Pending,
    Accepted,
    Rejected,
  }
  public class Incident
  {
    public int Id { get; set; }

    public int UserId { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string FolioNumber { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public DateTime DateReported { get; set; }
    public IncidentStatus Status { get; set; } = IncidentStatus.Pending;
    public string? ImagePath { get; set; }
    public int? AuthUserId { get; set; }
    public string? AuthUserName { get; set; }
    public DateTime? ResolutionDate { get; set; }
  }
}