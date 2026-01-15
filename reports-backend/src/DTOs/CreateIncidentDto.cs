namespace reports_backend.DTOs
{
  public class CreateIncidentDto
  {
    public string FolioNumber { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string? ImagePath { get; set; }
  }
}
