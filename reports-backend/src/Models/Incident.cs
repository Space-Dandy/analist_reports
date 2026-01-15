#nullable enable
using System;
using reports_backend.Models;

namespace reports_backend.Models
{
  public class Incident
  {
    public int Id { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = new User();
    public string FolioNumber { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public DateTime DateReported { get; set; }
    public string Status { get; set; } = string.Empty;
    public string? ImagePath { get; set; }
  }
}