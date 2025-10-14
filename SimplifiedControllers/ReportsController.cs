using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LegalCaseManagement.SimplifiedData;
using LegalCaseManagement.SimplifiedDTOs;

namespace LegalCaseManagement.SimplifiedControllers
{
    /// <summary>
    /// Simple Reports Controller - Generate basic reports and dashboard data
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class ReportsController : ControllerBase
    {
        private readonly SimpleDbContext _context;
        private readonly ILogger<ReportsController> _logger;

        public ReportsController(SimpleDbContext context, ILogger<ReportsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Get dashboard summary - Quick overview of the system
        /// </summary>
        [HttpGet("dashboard")]
        public async Task<ActionResult<DashboardSummary>> GetDashboard()
        {
            try
            {
                var now = DateTime.UtcNow;
                var oneWeekFromNow = now.AddDays(7);

                var totalCases = await _context.Cases.CountAsync();
                var activeCases = await _context.Cases.CountAsync(c => c.Status == "Active");
                
                var hearingsThisWeek = await _context.Hearings
                    .CountAsync(h => h.Status == "Scheduled" && 
                               h.Date >= now && h.Date <= oneWeekFromNow);
                
                var deadlinesThisWeek = await _context.Deadlines
                    .CountAsync(d => !d.IsCompleted && 
                               d.DueDate >= now && d.DueDate <= oneWeekFromNow);
                
                var overdueDeadlines = await _context.Deadlines
                    .CountAsync(d => !d.IsCompleted && d.DueDate < now);

                // Recent activity
                var recentActivity = new List<string>();
                
                var recentCases = await _context.Cases
                    .OrderByDescending(c => c.CreatedAt)
                    .Take(3)
                    .Select(c => $"New case created: {c.CaseNumber}")
                    .ToListAsync();
                
                recentActivity.AddRange(recentCases);

                var dashboard = new DashboardSummary
                {
                    TotalCases = totalCases,
                    ActiveCases = activeCases,
                    HearingsThisWeek = hearingsThisWeek,
                    DeadlinesThisWeek = deadlinesThisWeek,
                    OverdueDeadlines = overdueDeadlines,
                    RecentActivity = recentActivity
                };

                return Ok(dashboard);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error generating dashboard");
                return StatusCode(500, "Something went wrong while generating dashboard");
            }
        }

        /// <summary>
        /// Get comprehensive case report
        /// </summary>
        [HttpGet("cases")]
        public async Task<ActionResult<CaseReportResponse>> GetCaseReport()
        {
            try
            {
                var totalCases = await _context.Cases.CountAsync();
                var activeCases = await _context.Cases.CountAsync(c => c.Status == "Active");
                var closedCases = await _context.Cases.CountAsync(c => c.Status == "Closed");
                var pendingCases = await _context.Cases.CountAsync(c => c.Status == "Pending");

                var totalHearings = await _context.Hearings.CountAsync();
                var upcomingHearings = await _context.Hearings
                    .CountAsync(h => h.Status == "Scheduled" && h.Date > DateTime.UtcNow);

                var totalDeadlines = await _context.Deadlines.CountAsync();
                var overdueDeadlines = await _context.Deadlines
                    .CountAsync(d => !d.IsCompleted && d.DueDate < DateTime.UtcNow);

                // Recent cases
                var recentCases = await _context.Cases
                    .OrderByDescending(c => c.CreatedAt)
                    .Take(10)
                    .Select(c => new CaseSummary
                    {
                        Id = c.Id,
                        CaseNumber = c.CaseNumber,
                        Title = c.Title,
                        LawyerName = c.LawyerName,
                        Status = c.Status,
                        CourtName = c.CourtName,
                        DateFiled = c.DateFiled
                    })
                    .ToListAsync();

                // Upcoming hearings
                var upcomingHearingsList = await _context.Hearings
                    .Include(h => h.Case)
                    .Where(h => h.Status == "Scheduled" && h.Date > DateTime.UtcNow)
                    .OrderBy(h => h.Date)
                    .Take(10)
                    .Select(h => new HearingResponse
                    {
                        Id = h.Id,
                        CaseId = h.CaseId,
                        CaseNumber = h.Case.CaseNumber,
                        Date = h.Date,
                        Time = h.Time,
                        Location = h.Location,
                        Type = h.Type,
                        Status = h.Status,
                        CreatedAt = h.CreatedAt
                    })
                    .ToListAsync();

                // Overdue deadlines
                var overdueDeadlinesList = await _context.Deadlines
                    .Include(d => d.Case)
                    .Where(d => !d.IsCompleted && d.DueDate < DateTime.UtcNow)
                    .OrderBy(d => d.DueDate)
                    .Take(10)
                    .Select(d => new DeadlineResponse
                    {
                        Id = d.Id,
                        CaseId = d.CaseId,
                        CaseNumber = d.Case.CaseNumber,
                        DueDate = d.DueDate,
                        Description = d.Description,
                        Priority = d.Priority,
                        IsCompleted = d.IsCompleted,
                        CreatedAt = d.CreatedAt
                    })
                    .ToListAsync();

                var report = new CaseReportResponse
                {
                    TotalCases = totalCases,
                    ActiveCases = activeCases,
                    ClosedCases = closedCases,
                    PendingCases = pendingCases,
                    TotalHearings = totalHearings,
                    UpcomingHearings = upcomingHearings,
                    TotalDeadlines = totalDeadlines,
                    OverdueDeadlines = overdueDeadlines,
                    GeneratedAt = DateTime.UtcNow,
                    RecentCases = recentCases,
                    UpcomingHearingsList = upcomingHearingsList,
                    OverdueDeadlinesList = overdueDeadlinesList
                };

                return Ok(report);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error generating case report");
                return StatusCode(500, "Something went wrong while generating the report");
            }
        }

        /// <summary>
        /// Get cases by status
        /// </summary>
        [HttpGet("cases/status/{status}")]
        public async Task<ActionResult<List<CaseSummary>>> GetCasesByStatus(string status)
        {
            try
            {
                var cases = await _context.Cases
                    .Where(c => c.Status.ToLower() == status.ToLower())
                    .OrderByDescending(c => c.CreatedAt)
                    .Select(c => new CaseSummary
                    {
                        Id = c.Id,
                        CaseNumber = c.CaseNumber,
                        Title = c.Title,
                        LawyerName = c.LawyerName,
                        Status = c.Status,
                        CourtName = c.CourtName,
                        DateFiled = c.DateFiled
                    })
                    .ToListAsync();

                return Ok(cases);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting cases by status {Status}", status);
                return StatusCode(500, "Something went wrong while getting cases by status");
            }
        }

        /// <summary>
        /// Get cases by lawyer
        /// </summary>
        [HttpGet("cases/lawyer/{lawyerName}")]
        public async Task<ActionResult<List<CaseSummary>>> GetCasesByLawyer(string lawyerName)
        {
            try
            {
                var cases = await _context.Cases
                    .Where(c => c.LawyerName.ToLower().Contains(lawyerName.ToLower()))
                    .OrderByDescending(c => c.CreatedAt)
                    .Select(c => new CaseSummary
                    {
                        Id = c.Id,
                        CaseNumber = c.CaseNumber,
                        Title = c.Title,
                        LawyerName = c.LawyerName,
                        Status = c.Status,
                        CourtName = c.CourtName,
                        DateFiled = c.DateFiled
                    })
                    .ToListAsync();

                return Ok(cases);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting cases by lawyer {LawyerName}", lawyerName);
                return StatusCode(500, "Something went wrong while getting cases by lawyer");
            }
        }
    }
}