using FluentValidation;
using LegalCaseManagement.DTOs;

namespace LegalCaseManagement.Validators
{
    /// <summary>
    /// Validator for CreateHearingDto
    /// </summary>
    public class CreateHearingDtoValidator : AbstractValidator<CreateHearingDto>
    {
        public CreateHearingDtoValidator()
        {
            RuleFor(x => x.Date)
                .NotEmpty().WithMessage("Hearing date is required")
                .GreaterThan(DateTime.UtcNow.Date).WithMessage("Hearing date must be in the future");

            RuleFor(x => x.Time)
                .NotEmpty().WithMessage("Hearing time is required")
                .Must(BeValidTime).WithMessage("Hearing time must be between 8:00 AM and 6:00 PM");

            RuleFor(x => x.CourtId)
                .GreaterThan(0).WithMessage("Valid court ID is required")
                .When(x => x.CourtId.HasValue);

            RuleFor(x => x.Location)
                .MaximumLength(200).WithMessage("Location cannot exceed 200 characters")
                .When(x => !string.IsNullOrEmpty(x.Location));

            RuleFor(x => x.HearingType)
                .MaximumLength(100).WithMessage("Hearing type cannot exceed 100 characters")
                .Must(BeValidHearingType).WithMessage("Hearing type must be one of: Initial, Pre-trial, Trial, Post-trial, Appeal, Settlement")
                .When(x => !string.IsNullOrEmpty(x.HearingType));

            RuleFor(x => x.Remarks)
                .MaximumLength(500).WithMessage("Remarks cannot exceed 500 characters")
                .When(x => !string.IsNullOrEmpty(x.Remarks));
        }

        private bool BeValidTime(TimeSpan time)
        {
            // Business hours: 8:00 AM to 6:00 PM
            var startTime = new TimeSpan(8, 0, 0);  // 8:00 AM
            var endTime = new TimeSpan(18, 0, 0);   // 6:00 PM
            return time >= startTime && time <= endTime;
        }

        private bool BeValidHearingType(string hearingType)
        {
            var validTypes = new[] { "Initial", "Pre-trial", "Trial", "Post-trial", "Appeal", "Settlement", "Motion", "Conference" };
            return validTypes.Contains(hearingType, StringComparer.OrdinalIgnoreCase);
        }
    }

    /// <summary>
    /// Validator for UpdateHearingDto
    /// </summary>
    public class UpdateHearingDtoValidator : AbstractValidator<UpdateHearingDto>
    {
        public UpdateHearingDtoValidator()
        {
            RuleFor(x => x.Date)
                .GreaterThan(DateTime.UtcNow.Date).WithMessage("Hearing date must be in the future")
                .When(x => x.Date.HasValue);

            RuleFor(x => x.Time)
                .Must(BeValidTime).WithMessage("Hearing time must be between 8:00 AM and 6:00 PM")
                .When(x => x.Time.HasValue);

            RuleFor(x => x.CourtId)
                .GreaterThan(0).WithMessage("Valid court ID is required")
                .When(x => x.CourtId.HasValue);

            RuleFor(x => x.Location)
                .MaximumLength(200).WithMessage("Location cannot exceed 200 characters")
                .When(x => !string.IsNullOrEmpty(x.Location));

            RuleFor(x => x.HearingType)
                .MaximumLength(100).WithMessage("Hearing type cannot exceed 100 characters")
                .Must(BeValidHearingType).WithMessage("Hearing type must be one of: Initial, Pre-trial, Trial, Post-trial, Appeal, Settlement")
                .When(x => !string.IsNullOrEmpty(x.HearingType));

            RuleFor(x => x.Remarks)
                .MaximumLength(500).WithMessage("Remarks cannot exceed 500 characters")
                .When(x => !string.IsNullOrEmpty(x.Remarks));

            RuleFor(x => x.Status)
                .MaximumLength(50).WithMessage("Status cannot exceed 50 characters")
                .Must(BeValidStatus).WithMessage("Status must be one of: Scheduled, Completed, Postponed, Cancelled")
                .When(x => !string.IsNullOrEmpty(x.Status));
        }

        private bool BeValidTime(TimeSpan time)
        {
            var startTime = new TimeSpan(8, 0, 0);  // 8:00 AM
            var endTime = new TimeSpan(18, 0, 0);   // 6:00 PM
            return time >= startTime && time <= endTime;
        }

        private bool BeValidHearingType(string hearingType)
        {
            var validTypes = new[] { "Initial", "Pre-trial", "Trial", "Post-trial", "Appeal", "Settlement", "Motion", "Conference" };
            return validTypes.Contains(hearingType, StringComparer.OrdinalIgnoreCase);
        }

        private bool BeValidStatus(string status)
        {
            var validStatuses = new[] { "Scheduled", "Completed", "Postponed", "Cancelled" };
            return validStatuses.Contains(status, StringComparer.OrdinalIgnoreCase);
        }
    }
}