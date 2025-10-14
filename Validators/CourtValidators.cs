using FluentValidation;
using LegalCaseManagement.DTOs;

namespace LegalCaseManagement.Validators
{
    /// <summary>
    /// Validator for CreateCourtDto
    /// </summary>
    public class CreateCourtDtoValidator : AbstractValidator<CreateCourtDto>
    {
        public CreateCourtDtoValidator()
        {
            RuleFor(x => x.Name)
                .NotEmpty().WithMessage("Court name is required")
                .MaximumLength(200).WithMessage("Court name cannot exceed 200 characters");

            RuleFor(x => x.Type)
                .MaximumLength(100).WithMessage("Court type cannot exceed 100 characters")
                .Must(BeValidCourtType).WithMessage("Court type must be one of: District, Superior, Supreme, Federal, Municipal, Family, Juvenile")
                .When(x => !string.IsNullOrEmpty(x.Type));

            RuleFor(x => x.Address)
                .MaximumLength(300).WithMessage("Address cannot exceed 300 characters")
                .When(x => !string.IsNullOrEmpty(x.Address));

            RuleFor(x => x.City)
                .MaximumLength(100).WithMessage("City cannot exceed 100 characters")
                .Matches(@"^[a-zA-Z\s\-'\.]+$").WithMessage("City can only contain letters, spaces, hyphens, apostrophes, and periods")
                .When(x => !string.IsNullOrEmpty(x.City));

            RuleFor(x => x.State)
                .MaximumLength(50).WithMessage("State cannot exceed 50 characters")
                .Matches(@"^[a-zA-Z\s]+$").WithMessage("State can only contain letters and spaces")
                .When(x => !string.IsNullOrEmpty(x.State));

            RuleFor(x => x.ZipCode)
                .MaximumLength(20).WithMessage("Zip code cannot exceed 20 characters")
                .Matches(@"^[\d\-\s]+$").WithMessage("Zip code can only contain numbers, hyphens, and spaces")
                .When(x => !string.IsNullOrEmpty(x.ZipCode));

            RuleFor(x => x.Phone)
                .Matches(@"^\+?[\d\s\-\(\)\.]+$").WithMessage("Invalid phone number format")
                .MaximumLength(20).WithMessage("Phone number cannot exceed 20 characters")
                .When(x => !string.IsNullOrEmpty(x.Phone));
        }

        private bool BeValidCourtType(string courtType)
        {
            var validTypes = new[] { "District", "Superior", "Supreme", "Federal", "Municipal", "Family", "Juvenile", "Appeals", "Magistrate" };
            return validTypes.Contains(courtType, StringComparer.OrdinalIgnoreCase);
        }
    }
}