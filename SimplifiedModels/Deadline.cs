using System.ComponentModel.DataAnnotations;

namespace LegalCaseManagement.SimplifiedModels
{
    /// <summary>
    /// Simple Deadline model - represents important case deadlines
    /// </summary>
    public class Deadline
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int CaseId { get; set; }

        [Required]
        public DateTime DueDate { get; set; }

        [Required]
        public string Description { get; set; } = string.Empty;

        public string Priority { get; set; } = "Medium"; // High, Medium, Low

        public bool IsCompleted { get; set; } = false;

        public DateTime? CompletedDate { get; set; }

        public string? Notes { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation property
        public Case Case { get; set; } = null!;
    }
}