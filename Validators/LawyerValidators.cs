using FluentValidation;
using LegalCaseManagement.DTOs;

namespace LegalCaseManagement.Validators
{
    /// <summary>
    /// Validator for CreateLawyerDto
    /// </summary>
    public class CreateLawyerDtoValidator : AbstractValidator<CreateLawyerDto>
    {
        public CreateLawyerDtoValidator()
        {
            RuleFor(x => x.FirstName)
                .NotEmpty().WithMessage("First name is required")
                .MaximumLength(100).WithMessage("First name cannot exceed 100 characters")
                .Matches(@"^[a-zA-Z\s\-'\.]+$").WithMessage("First name can only contain letters, spaces, hyphens, apostrophes, and periods");

            RuleFor(x => x.LastName)
                .NotEmpty().WithMessage("Last name is required")
                .MaximumLength(100).WithMessage("Last name cannot exceed 100 characters")
                .Matches(@"^[a-zA-Z\s\-'\.]+$").WithMessage("Last name can only contain letters, spaces, hyphens, apostrophes, and periods");

            RuleFor(x => x.Email)
                .NotEmpty().WithMessage("Email is required")
                .EmailAddress().WithMessage("Invalid email format")
                .MaximumLength(200).WithMessage("Email cannot exceed 200 characters");

            RuleFor(x => x.Phone)
                .Matches(@"^\+?[\d\s\-\(\)\.]+$").WithMessage("Invalid phone number format")
                .MaximumLength(20).WithMessage("Phone number cannot exceed 20 characters")
                .When(x => !string.IsNullOrEmpty(x.Phone));

            RuleFor(x => x.BarNumber)
                .MaximumLength(50).WithMessage("Bar number cannot exceed 50 characters")
                .Matches(@"^[A-Z0-9\-]+$").WithMessage("Bar number can only contain uppercase letters, numbers, and hyphens")
                .When(x => !string.IsNullOrEmpty(x.BarNumber));

            RuleFor(x => x.Specialization)
                .MaximumLength(100).WithMessage("Specialization cannot exceed 100 characters")
                .When(x => !string.IsNullOrEmpty(x.Specialization));
        }
    }
}