using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LegalCaseManagement.SimplifiedData;
using LegalCaseManagement.SimplifiedModels;
using LegalCaseManagement.SimplifiedDTOs;

namespace LegalCaseManagement.SimplifiedControllers
{
    /// <summary>
    /// Simple Cases Controller - Easy to understand API for managing legal cases
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class CasesController : ControllerBase
    {
        private readonly SimpleDbContext _context;
        private readonly ILogger<CasesController> _logger;

        public CasesController(SimpleDbContext context, ILogger<CasesController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Get all cases - Returns a simple list of all cases
        /// </summary>
        [HttpGet]
        public async Task<ActionResult<List<CaseSummary>>> GetAllCases()
        {
            try
            {
                var cases = await _context.Cases
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
                _logger.LogError(ex, "Error getting all cases");
                return StatusCode(500, "Something went wrong while getting cases");
            }
        }

        /// <summary>
        /// Get a specific case by ID - Returns detailed case information
        /// </summary>
        [HttpGet("{id}")]
        public async Task<ActionResult<CaseResponse>> GetCase(int id)
        {
            try
            {
                var caseEntity = await _context.Cases
                    .Include(c => c.Hearings)
                    .Include(c => c.Deadlines)
                    .FirstOrDefaultAsync(c => c.Id == id);

                if (caseEntity == null)
                {
                    return NotFound($"Case with ID {id} not found");
                }

                var response = new CaseResponse
                {
                    Id = caseEntity.Id,
                    CaseNumber = caseEntity.CaseNumber,
                    Title = caseEntity.Title,
                    Description = caseEntity.Description,
                    LawyerName = caseEntity.LawyerName,
                    CourtName = caseEntity.CourtName,
                    DateFiled = caseEntity.DateFiled,
                    Status = caseEntity.Status,
                    Parties = caseEntity.Parties,
                    CreatedAt = caseEntity.CreatedAt,
                    TotalHearings = caseEntity.Hearings.Count,
                    TotalDeadlines = caseEntity.Deadlines.Count,
                    NextHearingDate = caseEntity.Hearings
                        .Where(h => h.Status == "Scheduled" && h.Date > DateTime.UtcNow)
                        .OrderBy(h => h.Date)
                        .Select(h => h.Date)
                        .FirstOrDefault(),
                    NextDeadlineDate = caseEntity.Deadlines
                        .Where(d => !d.IsCompleted && d.DueDate > DateTime.UtcNow)
                        .OrderBy(d => d.DueDate)
                        .Select(d => d.DueDate)
                        .FirstOrDefault()
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting case {CaseId}", id);
                return StatusCode(500, "Something went wrong while getting the case");
            }
        }

        /// <summary>
        /// Create a new case - Register a new legal case in the system
        /// </summary>
        [HttpPost]
        public async Task<ActionResult<CaseResponse>> CreateCase(CreateCaseRequest request)
        {
            try
            {
                // Check if case number already exists
                var existingCase = await _context.Cases
                    .FirstOrDefaultAsync(c => c.CaseNumber == request.CaseNumber);
                
                if (existingCase != null)
                {
                    return BadRequest("A case with this number already exists");
                }

                var newCase = new Case
                {
                    CaseNumber = request.CaseNumber,
                    Title = request.Title,
                    Description = request.Description,
                    LawyerName = request.LawyerName,
                    CourtName = request.CourtName,
                    DateFiled = request.DateFiled,
                    Status = request.Status,
                    Parties = request.Parties,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Cases.Add(newCase);
                await _context.SaveChangesAsync();

                var response = new CaseResponse
                {
                    Id = newCase.Id,
                    CaseNumber = newCase.CaseNumber,
                    Title = newCase.Title,
                    Description = newCase.Description,
                    LawyerName = newCase.LawyerName,
                    CourtName = newCase.CourtName,
                    DateFiled = newCase.DateFiled,
                    Status = newCase.Status,
                    Parties = newCase.Parties,
                    CreatedAt = newCase.CreatedAt,
                    TotalHearings = 0,
                    TotalDeadlines = 0
                };

                return CreatedAtAction(nameof(GetCase), new { id = newCase.Id }, response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating case");
                return StatusCode(500, "Something went wrong while creating the case");
            }
        }

        /// <summary>
        /// Update a case - Modify existing case information
        /// </summary>
        [HttpPut("{id}")]
        public async Task<ActionResult<CaseResponse>> UpdateCase(int id, UpdateCaseRequest request)
        {
            try
            {
                var caseEntity = await _context.Cases.FindAsync(id);
                if (caseEntity == null)
                {
                    return NotFound($"Case with ID {id} not found");
                }

                // Update only the fields that are provided
                if (!string.IsNullOrEmpty(request.Title))
                    caseEntity.Title = request.Title;
                
                if (request.Description != null)
                    caseEntity.Description = request.Description;
                
                if (!string.IsNullOrEmpty(request.LawyerName))
                    caseEntity.LawyerName = request.LawyerName;
                
                if (!string.IsNullOrEmpty(request.CourtName))
                    caseEntity.CourtName = request.CourtName;
                
                if (!string.IsNullOrEmpty(request.Status))
                    caseEntity.Status = request.Status;
                
                if (request.Parties != null)
                    caseEntity.Parties = request.Parties;

                await _context.SaveChangesAsync();

                // Return the updated case
                return await GetCase(id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating case {CaseId}", id);
                return StatusCode(500, "Something went wrong while updating the case");
            }
        }

        /// <summary>
        /// Delete a case - Remove a case from the system
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteCase(int id)
        {
            try
            {
                var caseEntity = await _context.Cases.FindAsync(id);
                if (caseEntity == null)
                {
                    return NotFound($"Case with ID {id} not found");
                }

                _context.Cases.Remove(caseEntity);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Case deleted successfully", caseId = id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting case {CaseId}", id);
                return StatusCode(500, "Something went wrong while deleting the case");
            }
        }

        /// <summary>
        /// Add a hearing to a case
        /// </summary>
        [HttpPost("{id}/hearings")]
        public async Task<ActionResult<HearingResponse>> AddHearing(int id, CreateHearingRequest request)
        {
            try
            {
                var caseEntity = await _context.Cases.FindAsync(id);
                if (caseEntity == null)
                {
                    return NotFound($"Case with ID {id} not found");
                }

                var hearing = new Hearing
                {
                    CaseId = id,
                    Date = request.Date,
                    Time = request.Time,
                    Location = request.Location,
                    Type = request.Type,
                    Notes = request.Notes,
                    Status = "Scheduled",
                    CreatedAt = DateTime.UtcNow
                };

                _context.Hearings.Add(hearing);
                await _context.SaveChangesAsync();

                var response = new HearingResponse
                {
                    Id = hearing.Id,
                    CaseId = hearing.CaseId,
                    CaseNumber = caseEntity.CaseNumber,
                    Date = hearing.Date,
                    Time = hearing.Time,
                    Location = hearing.Location,
                    Type = hearing.Type,
                    Notes = hearing.Notes,
                    Status = hearing.Status,
                    CreatedAt = hearing.CreatedAt
                };

                return CreatedAtAction(nameof(GetCase), new { id = id }, response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding hearing to case {CaseId}", id);
                return StatusCode(500, "Something went wrong while adding the hearing");
            }
        }

        /// <summary>
        /// Add a deadline to a case
        /// </summary>
        [HttpPost("{id}/deadlines")]
        public async Task<ActionResult<DeadlineResponse>> AddDeadline(int id, CreateDeadlineRequest request)
        {
            try
            {
                var caseEntity = await _context.Cases.FindAsync(id);
                if (caseEntity == null)
                {
                    return NotFound($"Case with ID {id} not found");
                }

                var deadline = new Deadline
                {
                    CaseId = id,
                    DueDate = request.DueDate,
                    Description = request.Description,
                    Priority = request.Priority,
                    Notes = request.Notes,
                    IsCompleted = false,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Deadlines.Add(deadline);
                await _context.SaveChangesAsync();

                var response = new DeadlineResponse
                {
                    Id = deadline.Id,
                    CaseId = deadline.CaseId,
                    CaseNumber = caseEntity.CaseNumber,
                    DueDate = deadline.DueDate,
                    Description = deadline.Description,
                    Priority = deadline.Priority,
                    IsCompleted = deadline.IsCompleted,
                    CompletedDate = deadline.CompletedDate,
                    Notes = deadline.Notes,
                    CreatedAt = deadline.CreatedAt
                };

                return CreatedAtAction(nameof(GetCase), new { id = id }, response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding deadline to case {CaseId}", id);
                return StatusCode(500, "Something went wrong while adding the deadline");
            }
        }
    }
}