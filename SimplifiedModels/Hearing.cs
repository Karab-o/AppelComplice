using System.ComponentModel.DataAnnotations;

namespace LegalCaseManagement.SimplifiedModels
{
    /// <summary>
    /// Simple Hearing model - represents a court hearing
    /// </summary>
    public class Hearing
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int CaseId { get; set; }

        [Required]
        public DateTime Date { get; set; }

        [Required]
        public TimeSpan Time { get; set; }

        public string? Location { get; set; }

        public string? Type { get; set; } // Initial, Trial, Final, etc.

        public string? Notes { get; set; }

        public string Status { get; set; } = "Scheduled"; // Scheduled, Completed, Cancelled

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation property
        public Case Case { get; set; } = null!;
    }
}