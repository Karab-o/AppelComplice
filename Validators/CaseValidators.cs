using FluentValidation;
using LegalCaseManagement.DTOs;

namespace LegalCaseManagement.Validators
{
    /// <summary>
    /// Validator for CreateCaseDto
    /// </summary>
    public class CreateCaseDtoValidator : AbstractValidator<CreateCaseDto>
    {
        public CreateCaseDtoValidator()
        {
            RuleFor(x => x.CaseNumber)
                .NotEmpty().WithMessage("Case number is required")
                .MaximumLength(50).WithMessage("Case number cannot exceed 50 characters")
                .Matches(@"^[A-Z0-9\-_]+$").WithMessage("Case number can only contain uppercase letters, numbers, hyphens, and underscores");

            RuleFor(x => x.Title)
                .NotEmpty().WithMessage("Title is required")
                .MaximumLength(200).WithMessage("Title cannot exceed 200 characters");

            RuleFor(x => x.Description)
                .MaximumLength(1000).WithMessage("Description cannot exceed 1000 characters");

            RuleFor(x => x.AssignedLawyerId)
                .GreaterThan(0).WithMessage("Valid assigned lawyer ID is required");

            RuleFor(x => x.CourtId)
                .GreaterThan(0).WithMessage("Valid court ID is required");

            RuleFor(x => x.DateFiled)
                .NotEmpty().WithMessage("Date filed is required")
                .LessThanOrEqualTo(DateTime.UtcNow).WithMessage("Date filed cannot be in the future");

            RuleFor(x => x.Status)
                .NotEmpty().WithMessage("Status is required")
                .MaximumLength(50).WithMessage("Status cannot exceed 50 characters")
                .Must(BeValidStatus).WithMessage("Status must be one of: Active, Pending, Closed, On Hold");

            RuleForEach(x => x.Parties)
                .SetValidator(new CasePartyDtoValidator())
                .When(x => x.Parties != null);
        }

        private bool BeValidStatus(string status)
        {
            var validStatuses = new[] { "Active", "Pending", "Closed", "On Hold" };
            return validStatuses.Contains(status, StringComparer.OrdinalIgnoreCase);
        }
    }

    /// <summary>
    /// Validator for UpdateCaseDto
    /// </summary>
    public class UpdateCaseDtoValidator : AbstractValidator<UpdateCaseDto>
    {
        public UpdateCaseDtoValidator()
        {
            RuleFor(x => x.Title)
                .MaximumLength(200).WithMessage("Title cannot exceed 200 characters")
                .When(x => !string.IsNullOrEmpty(x.Title));

            RuleFor(x => x.Description)
                .MaximumLength(1000).WithMessage("Description cannot exceed 1000 characters")
                .When(x => x.Description != null);

            RuleFor(x => x.AssignedLawyerId)
                .GreaterThan(0).WithMessage("Valid assigned lawyer ID is required")
                .When(x => x.AssignedLawyerId.HasValue);

            RuleFor(x => x.CourtId)
                .GreaterThan(0).WithMessage("Valid court ID is required")
                .When(x => x.CourtId.HasValue);

            RuleFor(x => x.Status)
                .MaximumLength(50).WithMessage("Status cannot exceed 50 characters")
                .Must(BeValidStatus).WithMessage("Status must be one of: Active, Pending, Closed, On Hold")
                .When(x => !string.IsNullOrEmpty(x.Status));

            RuleFor(x => x.Outcome)
                .MaximumLength(500).WithMessage("Outcome cannot exceed 500 characters")
                .When(x => x.Outcome != null);
        }

        private bool BeValidStatus(string status)
        {
            var validStatuses = new[] { "Active", "Pending", "Closed", "On Hold" };
            return validStatuses.Contains(status, StringComparer.OrdinalIgnoreCase);
        }
    }

    /// <summary>
    /// Validator for CasePartyDto
    /// </summary>
    public class CasePartyDtoValidator : AbstractValidator<CasePartyDto>
    {
        public CasePartyDtoValidator()
        {
            RuleFor(x => x.PartyId)
                .GreaterThan(0).WithMessage("Valid party ID is required");

            RuleFor(x => x.Role)
                .NotEmpty().WithMessage("Role is required")
                .MaximumLength(50).WithMessage("Role cannot exceed 50 characters")
                .Must(BeValidRole).WithMessage("Role must be one of: Plaintiff, Defendant, Witness, Attorney, Expert Witness, Third Party");
        }

        private bool BeValidRole(string role)
        {
            var validRoles = new[] { "Plaintiff", "Defendant", "Witness", "Attorney", "Expert Witness", "Third Party" };
            return validRoles.Contains(role, StringComparer.OrdinalIgnoreCase);
        }
    }
}