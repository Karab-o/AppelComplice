using System.ComponentModel.DataAnnotations;

namespace LegalCaseManagement.SimplifiedDTOs
{
    /// <summary>
    /// DTO for creating a deadline
    /// </summary>
    public class CreateDeadlineRequest
    {
        [Required(ErrorMessage = "Due date is required")]
        public DateTime DueDate { get; set; }

        [Required(ErrorMessage = "Description is required")]
        public string Description { get; set; } = string.Empty;

        public string Priority { get; set; } = "Medium"; // High, Medium, Low
        public string? Notes { get; set; }
    }

    /// <summary>
    /// DTO for updating a deadline
    /// </summary>
    public class UpdateDeadlineRequest
    {
        public DateTime? DueDate { get; set; }
        public string? Description { get; set; }
        public string? Priority { get; set; }
        public bool? IsCompleted { get; set; }
        public string? Notes { get; set; }
    }

    /// <summary>
    /// DTO for deadline response
    /// </summary>
    public class DeadlineResponse
    {
        public int Id { get; set; }
        public int CaseId { get; set; }
        public string CaseNumber { get; set; } = string.Empty;
        public DateTime DueDate { get; set; }
        public string Description { get; set; } = string.Empty;
        public string Priority { get; set; } = string.Empty;
        public bool IsCompleted { get; set; }
        public DateTime? CompletedDate { get; set; }
        public string? Notes { get; set; }
        public DateTime CreatedAt { get; set; }
        
        // Helper properties
        public int DaysUntilDue => (int)(DueDate - DateTime.UtcNow).TotalDays;
        public bool IsOverdue => !IsCompleted && DueDate < DateTime.UtcNow;
    }
}