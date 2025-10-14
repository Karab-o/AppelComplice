using FluentValidation;
using LegalCaseManagement.DTOs;

namespace LegalCaseManagement.Validators
{
    /// <summary>
    /// Validator for CreatePartyDto
    /// </summary>
    public class CreatePartyDtoValidator : AbstractValidator<CreatePartyDto>
    {
        public CreatePartyDtoValidator()
        {
            RuleFor(x => x.FirstName)
                .NotEmpty().WithMessage("First name is required")
                .MaximumLength(100).WithMessage("First name cannot exceed 100 characters")
                .Matches(@"^[a-zA-Z\s\-'\.]+$").WithMessage("First name can only contain letters, spaces, hyphens, apostrophes, and periods");

            RuleFor(x => x.LastName)
                .NotEmpty().WithMessage("Last name is required")
                .MaximumLength(100).WithMessage("Last name cannot exceed 100 characters")
                .Matches(@"^[a-zA-Z\s\-'\.]+$").WithMessage("Last name can only contain letters, spaces, hyphens, apostrophes, and periods");

            RuleFor(x => x.PartyType)
                .MaximumLength(50).WithMessage("Party type cannot exceed 50 characters")
                .Must(BeValidPartyType).WithMessage("Party type must be one of: Individual, Corporation, Government, Non-Profit, Partnership, LLC")
                .When(x => !string.IsNullOrEmpty(x.PartyType));

            RuleFor(x => x.Email)
                .EmailAddress().WithMessage("Invalid email format")
                .MaximumLength(200).WithMessage("Email cannot exceed 200 characters")
                .When(x => !string.IsNullOrEmpty(x.Email));

            RuleFor(x => x.Phone)
                .Matches(@"^\+?[\d\s\-\(\)\.]+$").WithMessage("Invalid phone number format")
                .MaximumLength(20).WithMessage("Phone number cannot exceed 20 characters")
                .When(x => !string.IsNullOrEmpty(x.Phone));

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
        }

        private bool BeValidPartyType(string partyType)
        {
            var validTypes = new[] { "Individual", "Corporation", "Government", "Non-Profit", "Partnership", "LLC", "Trust", "Estate" };
            return validTypes.Contains(partyType, StringComparer.OrdinalIgnoreCase);
        }
    }
}