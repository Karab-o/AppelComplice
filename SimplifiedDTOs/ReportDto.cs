namespace LegalCaseManagement.SimplifiedDTOs
{
    /// <summary>
    /// Simple report showing case statistics
    /// </summary>
    public class CaseReportResponse
    {
        public int TotalCases { get; set; }
        public int ActiveCases { get; set; }
        public int ClosedCases { get; set; }
        public int PendingCases { get; set; }
        public int TotalHearings { get; set; }
        public int UpcomingHearings { get; set; }
        public int TotalDeadlines { get; set; }
        public int OverdueDeadlines { get; set; }
        public DateTime GeneratedAt { get; set; } = DateTime.UtcNow;

        public List<CaseSummary> RecentCases { get; set; } = new();
        public List<HearingResponse> UpcomingHearingsList { get; set; } = new();
        public List<DeadlineResponse> OverdueDeadlinesList { get; set; } = new();
    }

    /// <summary>
    /// Simple dashboard summary
    /// </summary>
    public class DashboardSummary
    {
        public int TotalCases { get; set; }
        public int ActiveCases { get; set; }
        public int HearingsThisWeek { get; set; }
        public int DeadlinesThisWeek { get; set; }
        public int OverdueDeadlines { get; set; }
        
        public List<string> RecentActivity { get; set; } = new();
    }
}