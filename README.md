# Legal Case Management System API

A comprehensive ASP.NET Core 8 Web API for managing legal cases, hearings, deadlines, and generating reports for law firms and legal departments.

## 🚀 Features

### Core Functionality
- **Case Management**: Create, update, and track legal cases with complete lifecycle management
- **Party Management**: Manage plaintiffs, defendants, witnesses, and other case participants
- **Lawyer Management**: Track lawyer assignments, specializations, and caseloads
- **Court Management**: Maintain court information and scheduling
- **Hearing Scheduling**: Schedule and track court hearings with status updates
- **Deadline Tracking**: Manage case deadlines with priority levels and completion status
- **Comprehensive Reporting**: Generate detailed reports on cases, lawyer performance, and court utilization

### Technical Features
- **RESTful API Design**: Clean, intuitive endpoints following REST principles
- **Entity Framework Core**: Code-first database approach with automatic migrations
- **AutoMapper Integration**: Seamless object-to-object mapping
- **FluentValidation**: Comprehensive input validation with custom rules
- **Swagger Documentation**: Interactive API documentation and testing
- **Soft Delete**: Safe data removal without permanent deletion
- **Relationship Management**: Complex many-to-many and one-to-many relationships
- **Error Handling**: Comprehensive error handling with meaningful messages

## 📋 Database Schema

### Entity Relationships

```
Case (1) ←→ (M) Hearing
Case (1) ←→ (M) Deadline
Case (M) ←→ (1) Lawyer
Case (M) ←→ (1) Court
Case (M) ←→ (M) Party (via CaseParty junction table)
Hearing (M) ←→ (1) Court
```

### Key Entities

- **Case**: Core entity representing legal cases
- **Lawyer**: Legal professionals handling cases
- **Court**: Court systems where cases are filed
- **Party**: Individuals or entities involved in cases
- **Hearing**: Scheduled court appearances
- **Deadline**: Important dates and milestones
- **CaseParty**: Junction table managing case-party relationships

## 🛠️ Technology Stack

- **Framework**: ASP.NET Core 8.0
- **Database**: SQL Server with Entity Framework Core
- **ORM**: Entity Framework Core 8.0
- **Mapping**: AutoMapper 12.0
- **Validation**: FluentValidation 11.8
- **Documentation**: Swagger/OpenAPI
- **Logging**: Built-in ASP.NET Core logging

## 🚦 Getting Started

### Prerequisites

- .NET 8.0 SDK or later
- SQL Server (LocalDB, Express, or Full)
- Visual Studio 2022 or VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd LegalCaseManagement
   ```

2. **Restore packages**
   ```bash
   dotnet restore
   ```

3. **Update connection string**
   
   Edit `appsettings.json` to configure your database connection:
   ```json
   {
     "ConnectionStrings": {
       "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=LegalCaseManagementDb;Trusted_Connection=true;MultipleActiveResultSets=true"
     }
   }
   ```

4. **Run the application**
   ```bash
   dotnet run
   ```

5. **Access the API**
   - API Base URL: `https://localhost:7000` or `http://localhost:5000`
   - Swagger UI: `https://localhost:7000` (root URL in development)

### Database Setup

The application uses Entity Framework Code-First approach. The database will be automatically created when you first run the application. Sample data is seeded automatically.

For production environments, use migrations:
```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
```

## 📚 API Endpoints

### Cases Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/cases` | Get all active cases |
| GET | `/api/cases/{id}` | Get case details by ID |
| POST | `/api/cases` | Create a new case |
| PUT | `/api/cases/{id}` | Update case information |
| DELETE | `/api/cases/{id}` | Soft delete a case |
| POST | `/api/cases/{id}/hearings` | Add hearing to case |
| POST | `/api/cases/{id}/deadlines` | Add deadline to case |
| PUT | `/api/cases/{id}/hearings/{hearingId}` | Update hearing |
| PUT | `/api/cases/{id}/deadlines/{deadlineId}` | Update deadline |

### Lawyers Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/lawyers` | Get all active lawyers |
| GET | `/api/lawyers/{id}` | Get lawyer by ID |
| POST | `/api/lawyers` | Create a new lawyer |
| PUT | `/api/lawyers/{id}` | Update lawyer information |
| DELETE | `/api/lawyers/{id}` | Deactivate lawyer |

### Courts Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/courts` | Get all active courts |
| GET | `/api/courts/{id}` | Get court by ID |
| POST | `/api/courts` | Create a new court |
| PUT | `/api/courts/{id}` | Update court information |
| DELETE | `/api/courts/{id}` | Deactivate court |

### Parties Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/parties` | Get all active parties |
| GET | `/api/parties/{id}` | Get party by ID |
| POST | `/api/parties` | Create a new party |
| PUT | `/api/parties/{id}` | Update party information |
| DELETE | `/api/parties/{id}` | Deactivate party |
| GET | `/api/parties/{id}/cases` | Get cases for a party |

### Reports & Analytics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/reports` | Generate comprehensive case report |
| GET | `/api/reports/deadlines` | Get deadline summary |
| GET | `/api/reports/lawyers` | Get lawyer performance report |
| GET | `/api/reports/courts` | Get court utilization report |
| GET | `/api/reports/cases/status/{status}` | Get cases by status |
| GET | `/api/reports/cases/lawyer/{lawyerId}` | Get cases by lawyer |
| GET | `/api/reports/cases/court/{courtId}` | Get cases by court |
| GET | `/api/reports/hearings/upcoming` | Get upcoming hearings |
| GET | `/api/reports/deadlines/overdue` | Get overdue deadlines |

## 📝 Request/Response Examples

### Create a New Case

**POST** `/api/cases`

```json
{
  "caseNumber": "CASE-2024-001",
  "title": "Smith vs. Johnson Contract Dispute",
  "description": "Contract dispute regarding service agreement terms",
  "assignedLawyerId": 1,
  "courtId": 1,
  "dateFiled": "2024-01-15T00:00:00Z",
  "status": "Active",
  "parties": [
    {
      "partyId": 1,
      "role": "Plaintiff"
    },
    {
      "partyId": 2,
      "role": "Defendant"
    }
  ]
}
```

**Response** (201 Created):
```json
{
  "caseId": 1,
  "caseNumber": "CASE-2024-001",
  "title": "Smith vs. Johnson Contract Dispute",
  "description": "Contract dispute regarding service agreement terms",
  "status": "Active",
  "outcome": null,
  "dateFiled": "2024-01-15T00:00:00Z",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": null,
  "assignedLawyer": {
    "lawyerId": 1,
    "firstName": "John",
    "lastName": "Smith",
    "fullName": "John Smith",
    "email": "john.smith@lawfirm.com",
    "phone": "555-0101",
    "barNumber": "BAR001",
    "specialization": "Criminal Law"
  },
  "court": {
    "courtId": 1,
    "name": "Superior Court of Justice",
    "type": "Superior",
    "address": "123 Justice Blvd",
    "city": "Downtown",
    "state": "CA",
    "zipCode": "90210",
    "phone": "555-0201"
  },
  "parties": [
    {
      "casePartyId": 1,
      "role": "Plaintiff",
      "party": {
        "partyId": 1,
        "firstName": "Alice",
        "lastName": "Williams",
        "fullName": "Alice Williams",
        "partyType": "Individual",
        "email": "alice.williams@email.com",
        "phone": "555-0301",
        "address": "789 Main Street",
        "city": "Downtown",
        "state": "CA",
        "zipCode": "90210"
      }
    }
  ],
  "hearings": [],
  "deadlines": []
}
```

### Add a Hearing to a Case

**POST** `/api/cases/1/hearings`

```json
{
  "date": "2024-02-15T00:00:00Z",
  "time": "10:30:00",
  "courtId": 1,
  "location": "Courtroom 3A",
  "hearingType": "Initial",
  "remarks": "Initial hearing for case review"
}
```

### Generate Case Report

**GET** `/api/reports`

**Response**:
```json
{
  "totalCases": 15,
  "activeCases": 12,
  "closedCases": 2,
  "pendingCases": 1,
  "cases": [
    {
      "caseId": 1,
      "caseNumber": "CASE-2024-001",
      "title": "Smith vs. Johnson Contract Dispute",
      "status": "Active",
      "lawyerName": "John Smith",
      "courtName": "Superior Court of Justice",
      "dateFiled": "2024-01-15T00:00:00Z",
      "totalHearings": 2,
      "completedHearings": 1,
      "totalDeadlines": 3,
      "completedDeadlines": 1,
      "overdueDeadlines": 0,
      "nextHearingDate": "2024-02-15T00:00:00Z",
      "nextDeadlineDate": "2024-02-10T00:00:00Z"
    }
  ],
  "lawyerCaseloads": [
    {
      "lawyerId": 1,
      "lawyerName": "John Smith",
      "specialization": "Criminal Law",
      "totalCases": 8,
      "activeCases": 6,
      "closedCases": 2,
      "upcomingHearings": 4,
      "overdueDeadlines": 0
    }
  ],
  "courtCaseloads": [
    {
      "courtId": 1,
      "courtName": "Superior Court of Justice",
      "courtType": "Superior",
      "totalCases": 10,
      "activeCases": 8,
      "upcomingHearings": 5
    }
  ],
  "generatedAt": "2024-01-15T10:30:00Z"
}
```

## 🔧 Configuration

### Connection Strings

Configure your database connection in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your-server;Database=LegalCaseManagementDb;Trusted_Connection=true;MultipleActiveResultSets=true"
  }
}
```

### Logging

Adjust logging levels in `appsettings.json`:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore": "Information"
    }
  }
}
```

## 🧪 Testing

### Using Swagger UI

1. Run the application
2. Navigate to the root URL (Swagger UI is set as default)
3. Explore and test all endpoints interactively

### Sample Data

The application includes seeded data:
- 2 Lawyers (John Smith, Sarah Johnson)
- 2 Courts (Superior Court, District Court)
- 2 Parties (Alice Williams, Bob Davis)

## 🔒 Validation Rules

### Case Validation
- Case number: Required, max 50 chars, alphanumeric with hyphens/underscores
- Title: Required, max 200 chars
- Status: Must be one of "Active", "Pending", "Closed", "On Hold"
- Date filed: Cannot be in the future

### Hearing Validation
- Date: Must be in the future
- Time: Must be between 8:00 AM and 6:00 PM
- Hearing type: Must be valid type (Initial, Pre-trial, Trial, etc.)

### Deadline Validation
- Due date: Must be in the future
- Priority: Must be "High", "Medium", or "Low"
- Description: Required, max 200 chars

## 🚨 Error Handling

The API provides comprehensive error handling:

- **400 Bad Request**: Invalid input data or validation errors
- **404 Not Found**: Resource not found
- **500 Internal Server Error**: Server-side errors

Example error response:
```json
{
  "message": "Validation failed",
  "errors": {
    "CaseNumber": ["Case number is required"],
    "AssignedLawyerId": ["Valid assigned lawyer ID is required"]
  }
}
```

## 📈 Performance Considerations

- **Lazy Loading**: Disabled for better performance control
- **Eager Loading**: Used strategically with `Include()` statements
- **Indexing**: Unique indexes on case numbers, emails, and bar numbers
- **Soft Deletes**: Maintains data integrity while allowing "deletion"
- **Pagination**: Consider implementing for large datasets

## 🔄 Future Enhancements

- Authentication and authorization
- Document management
- Email notifications for deadlines
- Calendar integration
- Advanced search and filtering
- Audit trails
- File attachments
- Time tracking
- Billing integration

## 📞 Support

For support or questions about this API:
- Review the Swagger documentation at the root URL
- Check the validation rules in the `Validators` folder
- Examine the entity models in the `Models` folder

## 📄 License

This project is licensed under the MIT License.