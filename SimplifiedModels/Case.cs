using System.ComponentModel.DataAnnotations;

namespace LegalCaseManagement.SimplifiedModels
{
    /// <summary>
    /// Simple Case model - represents a legal case
    /// </summary>
    public class Case
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string CaseNumber { get; set; } = string.Empty;

        [Required]
        public string Title { get; set; } = string.Empty;

        public string? Description { get; set; }

        [Required]
        public string LawyerName { get; set; } = string.Empty;

        [Required]
        public string CourtName { get; set; } = string.Empty;

        [Required]
        public DateTime DateFiled { get; set; }

        [Required]
        public string Status { get; set; } = "Active"; // Active, Closed, Pending

        public string? Parties { get; set; } // Simple string list: "John Doe (Plaintiff), Jane Smith (Defendant)"

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties for related data
        public List<Hearing> Hearings { get; set; } = new List<Hearing>();
        public List<Deadline> Deadlines { get; set; } = new List<Deadline>();
    }
}