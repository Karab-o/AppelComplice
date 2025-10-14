using System.ComponentModel.DataAnnotations;

namespace LegalCaseManagement.SimplifiedDTOs
{
    /// <summary>
    /// DTO for creating a new case - simple and easy to understand
    /// </summary>
    public class CreateCaseRequest
    {
        [Required(ErrorMessage = "Case number is required")]
        public string CaseNumber { get; set; } = string.Empty;

        [Required(ErrorMessage = "Title is required")]
        public string Title { get; set; } = string.Empty;

        public string? Description { get; set; }

        [Required(ErrorMessage = "Lawyer name is required")]
        public string LawyerName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Court name is required")]
        public string CourtName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Date filed is required")]
        public DateTime DateFiled { get; set; }

        public string Status { get; set; } = "Active";

        public string? Parties { get; set; } // "John Doe (Plaintiff), Jane Smith (Defendant)"
    }

    /// <summary>
    /// DTO for updating a case
    /// </summary>
    public class UpdateCaseRequest
    {
        public string? Title { get; set; }
        public string? Description { get; set; }
        public string? LawyerName { get; set; }
        public string? CourtName { get; set; }
        public string? Status { get; set; }
        public string? Parties { get; set; }
    }

    /// <summary>
    /// DTO for case response - what we send back to the client
    /// </summary>
    public class CaseResponse
    {
        public int Id { get; set; }
        public string CaseNumber { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string LawyerName { get; set; } = string.Empty;
        public string CourtName { get; set; } = string.Empty;
        public DateTime DateFiled { get; set; }
        public string Status { get; set; } = string.Empty;
        public string? Parties { get; set; }
        public DateTime CreatedAt { get; set; }
        
        // Summary info
        public int TotalHearings { get; set; }
        public int TotalDeadlines { get; set; }
        public DateTime? NextHearingDate { get; set; }
        public DateTime? NextDeadlineDate { get; set; }
    }

    /// <summary>
    /// Simple case summary for lists
    /// </summary>
    public class CaseSummary
    {
        public int Id { get; set; }
        public string CaseNumber { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string LawyerName { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string CourtName { get; set; } = string.Empty;
        public DateTime DateFiled { get; set; }
    }
}