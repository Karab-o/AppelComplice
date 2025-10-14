using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LegalCaseManagement.SimplifiedData;
using LegalCaseManagement.SimplifiedDTOs;

namespace LegalCaseManagement.SimplifiedControllers
{
    /// <summary>
    /// Simple Deadlines Controller - Manage case deadlines
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class DeadlinesController : ControllerBase
    {
        private readonly SimpleDbContext _context;
        private readonly ILogger<DeadlinesController> _logger;

        public DeadlinesController(SimpleDbContext context, ILogger<DeadlinesController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Get all deadlines
        /// </summary>
        [HttpGet]
        public async Task<ActionResult<List<DeadlineResponse>>> GetAllDeadlines()
        {
            try
            {
                var deadlines = await _context.Deadlines
                    .Include(d => d.Case)
                    .OrderBy(d => d.DueDate)
                    .Select(d => new DeadlineResponse
                    {
                        Id = d.Id,
                        CaseId = d.CaseId,
                        CaseNumber = d.Case.CaseNumber,
                        DueDate = d.DueDate,
                        Description = d.Description,
                        Priority = d.Priority,
                        IsCompleted = d.IsCompleted,
                        CompletedDate = d.CompletedDate,
                        Notes = d.Notes,
                        CreatedAt = d.CreatedAt
                    })
                    .ToListAsync();

                return Ok(deadlines);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting deadlines");
                return StatusCode(500, "Something went wrong while getting deadlines");
            }
        }

        /// <summary>
        /// Get overdue deadlines
        /// </summary>
        [HttpGet("overdue")]
        public async Task<ActionResult<List<DeadlineResponse>>> GetOverdueDeadlines()
        {
            try
            {
                var deadlines = await _context.Deadlines
                    .Include(d => d.Case)
                    .Where(d => !d.IsCompleted && d.DueDate < DateTime.UtcNow)
                    .OrderBy(d => d.DueDate)
                    .Select(d => new DeadlineResponse
                    {
                        Id = d.Id,
                        CaseId = d.CaseId,
                        CaseNumber = d.Case.CaseNumber,
                        DueDate = d.DueDate,
                        Description = d.Description,
                        Priority = d.Priority,
                        IsCompleted = d.IsCompleted,
                        CompletedDate = d.CompletedDate,
                        Notes = d.Notes,
                        CreatedAt = d.CreatedAt
                    })
                    .ToListAsync();

                return Ok(deadlines);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting overdue deadlines");
                return StatusCode(500, "Something went wrong while getting overdue deadlines");
            }
        }

        /// <summary>
        /// Mark a deadline as completed
        /// </summary>
        [HttpPost("{id}/complete")]
        public async Task<ActionResult<DeadlineResponse>> CompleteDeadline(int id)
        {
            try
            {
                var deadline = await _context.Deadlines
                    .Include(d => d.Case)
                    .FirstOrDefaultAsync(d => d.Id == id);

                if (deadline == null)
                {
                    return NotFound($"Deadline with ID {id} not found");
                }

                if (deadline.IsCompleted)
                {
                    return BadRequest("Deadline is already completed");
                }

                deadline.IsCompleted = true;
                deadline.CompletedDate = DateTime.UtcNow;

                await _context.SaveChangesAsync();

                var response = new DeadlineResponse
                {
                    Id = deadline.Id,
                    CaseId = deadline.CaseId,
                    CaseNumber = deadline.Case.CaseNumber,
                    DueDate = deadline.DueDate,
                    Description = deadline.Description,
                    Priority = deadline.Priority,
                    IsCompleted = deadline.IsCompleted,
                    CompletedDate = deadline.CompletedDate,
                    Notes = deadline.Notes,
                    CreatedAt = deadline.CreatedAt
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error completing deadline {DeadlineId}", id);
                return StatusCode(500, "Something went wrong while completing the deadline");
            }
        }

        /// <summary>
        /// Update a deadline
        /// </summary>
        [HttpPut("{id}")]
        public async Task<ActionResult<DeadlineResponse>> UpdateDeadline(int id, UpdateDeadlineRequest request)
        {
            try
            {
                var deadline = await _context.Deadlines
                    .Include(d => d.Case)
                    .FirstOrDefaultAsync(d => d.Id == id);

                if (deadline == null)
                {
                    return NotFound($"Deadline with ID {id} not found");
                }

                // Update fields if provided
                if (request.DueDate.HasValue)
                    deadline.DueDate = request.DueDate.Value;
                
                if (request.Description != null)
                    deadline.Description = request.Description;
                
                if (request.Priority != null)
                    deadline.Priority = request.Priority;
                
                if (request.Notes != null)
                    deadline.Notes = request.Notes;
                
                if (request.IsCompleted.HasValue)
                {
                    deadline.IsCompleted = request.IsCompleted.Value;
                    if (deadline.IsCompleted && !deadline.CompletedDate.HasValue)
                    {
                        deadline.CompletedDate = DateTime.UtcNow;
                    }
                    else if (!deadline.IsCompleted)
                    {
                        deadline.CompletedDate = null;
                    }
                }

                await _context.SaveChangesAsync();

                var response = new DeadlineResponse
                {
                    Id = deadline.Id,
                    CaseId = deadline.CaseId,
                    CaseNumber = deadline.Case.CaseNumber,
                    DueDate = deadline.DueDate,
                    Description = deadline.Description,
                    Priority = deadline.Priority,
                    IsCompleted = deadline.IsCompleted,
                    CompletedDate = deadline.CompletedDate,
                    Notes = deadline.Notes,
                    CreatedAt = deadline.CreatedAt
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating deadline {DeadlineId}", id);
                return StatusCode(500, "Something went wrong while updating the deadline");
            }
        }

        /// <summary>
        /// Delete a deadline
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteDeadline(int id)
        {
            try
            {
                var deadline = await _context.Deadlines.FindAsync(id);
                if (deadline == null)
                {
                    return NotFound($"Deadline with ID {id} not found");
                }

                _context.Deadlines.Remove(deadline);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Deadline deleted successfully", deadlineId = id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting deadline {DeadlineId}", id);
                return StatusCode(500, "Something went wrong while deleting the deadline");
            }
        }
    }
}