using FluentValidation;
using LegalCaseManagement.DTOs;

namespace LegalCaseManagement.Validators
{
    /// <summary>
    /// Validator for CreateDeadlineDto
    /// </summary>
    public class CreateDeadlineDtoValidator : AbstractValidator<CreateDeadlineDto>
    {
        public CreateDeadlineDtoValidator()
        {
            RuleFor(x => x.DueDate)
                .NotEmpty().WithMessage("Due date is required")
                .GreaterThan(DateTime.UtcNow).WithMessage("Due date must be in the future");

            RuleFor(x => x.Description)
                .NotEmpty().WithMessage("Description is required")
                .MaximumLength(200).WithMessage("Description cannot exceed 200 characters");

            RuleFor(x => x.Priority)
                .MaximumLength(50).WithMessage("Priority cannot exceed 50 characters")
                .Must(BeValidPriority).WithMessage("Priority must be one of: High, Medium, Low")
                .When(x => !string.IsNullOrEmpty(x.Priority));

            RuleFor(x => x.Notes)
                .MaximumLength(500).WithMessage("Notes cannot exceed 500 characters")
                .When(x => !string.IsNullOrEmpty(x.Notes));
        }

        private bool BeValidPriority(string priority)
        {
            var validPriorities = new[] { "High", "Medium", "Low" };
            return validPriorities.Contains(priority, StringComparer.OrdinalIgnoreCase);
        }
    }

    /// <summary>
    /// Validator for UpdateDeadlineDto
    /// </summary>
    public class UpdateDeadlineDtoValidator : AbstractValidator<UpdateDeadlineDto>
    {
        public UpdateDeadlineDtoValidator()
        {
            RuleFor(x => x.DueDate)
                .GreaterThan(DateTime.UtcNow).WithMessage("Due date must be in the future")
                .When(x => x.DueDate.HasValue);

            RuleFor(x => x.Description)
                .NotEmpty().WithMessage("Description cannot be empty")
                .MaximumLength(200).WithMessage("Description cannot exceed 200 characters")
                .When(x => !string.IsNullOrEmpty(x.Description));

            RuleFor(x => x.Priority)
                .MaximumLength(50).WithMessage("Priority cannot exceed 50 characters")
                .Must(BeValidPriority).WithMessage("Priority must be one of: High, Medium, Low")
                .When(x => !string.IsNullOrEmpty(x.Priority));

            RuleFor(x => x.Notes)
                .MaximumLength(500).WithMessage("Notes cannot exceed 500 characters")
                .When(x => !string.IsNullOrEmpty(x.Notes));

            // Custom validation: If marking as completed, ensure it's not already completed
            RuleFor(x => x.IsCompleted)
                .Must((dto, isCompleted) => !isCompleted.HasValue || isCompleted.Value)
                .WithMessage("Cannot mark a deadline as incomplete once it's been completed")
                .When(x => x.IsCompleted.HasValue);
        }

        private bool BeValidPriority(string priority)
        {
            var validPriorities = new[] { "High", "Medium", "Low" };
            return validPriorities.Contains(priority, StringComparer.OrdinalIgnoreCase);
        }
    }
}