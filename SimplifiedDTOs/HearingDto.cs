using System.ComponentModel.DataAnnotations;

namespace LegalCaseManagement.SimplifiedDTOs
{
    /// <summary>
    /// DTO for creating a hearing
    /// </summary>
    public class CreateHearingRequest
    {
        [Required(ErrorMessage = "Date is required")]
        public DateTime Date { get; set; }

        [Required(ErrorMessage = "Time is required")]
        public TimeSpan Time { get; set; }

        public string? Location { get; set; }
        public string? Type { get; set; }
        public string? Notes { get; set; }
    }

    /// <summary>
    /// DTO for updating a hearing
    /// </summary>
    public class UpdateHearingRequest
    {
        public DateTime? Date { get; set; }
        public TimeSpan? Time { get; set; }
        public string? Location { get; set; }
        public string? Type { get; set; }
        public string? Notes { get; set; }
        public string? Status { get; set; }
    }

    /// <summary>
    /// DTO for hearing response
    /// </summary>
    public class HearingResponse
    {
        public int Id { get; set; }
        public int CaseId { get; set; }
        public string CaseNumber { get; set; } = string.Empty;
        public DateTime Date { get; set; }
        public TimeSpan Time { get; set; }
        public string? Location { get; set; }
        public string? Type { get; set; }
        public string? Notes { get; set; }
        public string Status { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }
}