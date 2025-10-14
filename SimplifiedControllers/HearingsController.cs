using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LegalCaseManagement.SimplifiedData;
using LegalCaseManagement.SimplifiedDTOs;

namespace LegalCaseManagement.SimplifiedControllers
{
    /// <summary>
    /// Simple Hearings Controller - Manage court hearings
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class HearingsController : ControllerBase
    {
        private readonly SimpleDbContext _context;
        private readonly ILogger<HearingsController> _logger;

        public HearingsController(SimpleDbContext context, ILogger<HearingsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Get all hearings
        /// </summary>
        [HttpGet]
        public async Task<ActionResult<List<HearingResponse>>> GetAllHearings()
        {
            try
            {
                var hearings = await _context.Hearings
                    .Include(h => h.Case)
                    .OrderBy(h => h.Date)
                    .Select(h => new HearingResponse
                    {
                        Id = h.Id,
                        CaseId = h.CaseId,
                        CaseNumber = h.Case.CaseNumber,
                        Date = h.Date,
                        Time = h.Time,
                        Location = h.Location,
                        Type = h.Type,
                        Notes = h.Notes,
                        Status = h.Status,
                        CreatedAt = h.CreatedAt
                    })
                    .ToListAsync();

                return Ok(hearings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting hearings");
                return StatusCode(500, "Something went wrong while getting hearings");
            }
        }

        /// <summary>
        /// Get upcoming hearings (next 30 days)
        /// </summary>
        [HttpGet("upcoming")]
        public async Task<ActionResult<List<HearingResponse>>> GetUpcomingHearings()
        {
            try
            {
                var thirtyDaysFromNow = DateTime.UtcNow.AddDays(30);
                
                var hearings = await _context.Hearings
                    .Include(h => h.Case)
                    .Where(h => h.Status == "Scheduled" && 
                               h.Date > DateTime.UtcNow && 
                               h.Date <= thirtyDaysFromNow)
                    .OrderBy(h => h.Date)
                    .Select(h => new HearingResponse
                    {
                        Id = h.Id,
                        CaseId = h.CaseId,
                        CaseNumber = h.Case.CaseNumber,
                        Date = h.Date,
                        Time = h.Time,
                        Location = h.Location,
                        Type = h.Type,
                        Notes = h.Notes,
                        Status = h.Status,
                        CreatedAt = h.CreatedAt
                    })
                    .ToListAsync();

                return Ok(hearings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting upcoming hearings");
                return StatusCode(500, "Something went wrong while getting upcoming hearings");
            }
        }

        /// <summary>
        /// Update a hearing
        /// </summary>
        [HttpPut("{id}")]
        public async Task<ActionResult<HearingResponse>> UpdateHearing(int id, UpdateHearingRequest request)
        {
            try
            {
                var hearing = await _context.Hearings
                    .Include(h => h.Case)
                    .FirstOrDefaultAsync(h => h.Id == id);

                if (hearing == null)
                {
                    return NotFound($"Hearing with ID {id} not found");
                }

                // Update fields if provided
                if (request.Date.HasValue)
                    hearing.Date = request.Date.Value;
                
                if (request.Time.HasValue)
                    hearing.Time = request.Time.Value;
                
                if (request.Location != null)
                    hearing.Location = request.Location;
                
                if (request.Type != null)
                    hearing.Type = request.Type;
                
                if (request.Notes != null)
                    hearing.Notes = request.Notes;
                
                if (request.Status != null)
                    hearing.Status = request.Status;

                await _context.SaveChangesAsync();

                var response = new HearingResponse
                {
                    Id = hearing.Id,
                    CaseId = hearing.CaseId,
                    CaseNumber = hearing.Case.CaseNumber,
                    Date = hearing.Date,
                    Time = hearing.Time,
                    Location = hearing.Location,
                    Type = hearing.Type,
                    Notes = hearing.Notes,
                    Status = hearing.Status,
                    CreatedAt = hearing.CreatedAt
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating hearing {HearingId}", id);
                return StatusCode(500, "Something went wrong while updating the hearing");
            }
        }

        /// <summary>
        /// Delete a hearing
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteHearing(int id)
        {
            try
            {
                var hearing = await _context.Hearings.FindAsync(id);
                if (hearing == null)
                {
                    return NotFound($"Hearing with ID {id} not found");
                }

                _context.Hearings.Remove(hearing);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Hearing deleted successfully", hearingId = id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting hearing {HearingId}", id);
                return StatusCode(500, "Something went wrong while deleting the hearing");
            }
        }
    }
}