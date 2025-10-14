# 📚 Simple Legal Case Management API

A **super simple** and **easy-to-understand** API for managing legal cases. Perfect for learning and explaining how web APIs work!

## 🎯 What Does This API Do?

This API helps law firms manage their cases by providing simple endpoints to:

1. **Create and manage legal cases**
2. **Schedule court hearings**
3. **Track important deadlines**
4. **Generate basic reports**

## 🏗️ Simple Structure

### 3 Main Data Types (Models):

1. **Case** - A legal case with basic info
2. **Hearing** - A court appointment 
3. **Deadline** - An important date to remember

### 4 Controllers (API Endpoints):

1. **CasesController** - Manage cases
2. **HearingsController** - Manage hearings
3. **DeadlinesController** - Manage deadlines
4. **ReportsController** - Get summaries and reports

## 🚀 How to Run

1. **Install .NET 8**
2. **Run these commands:**
   ```bash
   dotnet restore
   dotnet run
   ```
3. **Open your browser to:** `https://localhost:7000`
4. **You'll see Swagger UI** - a web page where you can test all the APIs!

## 📋 All API Endpoints

### 📁 Cases (`/api/cases`)
- `GET /api/cases` - Get all cases
- `GET /api/cases/{id}` - Get one case
- `POST /api/cases` - Create new case
- `PUT /api/cases/{id}` - Update case
- `DELETE /api/cases/{id}` - Delete case
- `POST /api/cases/{id}/hearings` - Add hearing to case
- `POST /api/cases/{id}/deadlines` - Add deadline to case

### 📅 Hearings (`/api/hearings`)
- `GET /api/hearings` - Get all hearings
- `GET /api/hearings/upcoming` - Get upcoming hearings
- `PUT /api/hearings/{id}` - Update hearing
- `DELETE /api/hearings/{id}` - Delete hearing

### ⏰ Deadlines (`/api/deadlines`)
- `GET /api/deadlines` - Get all deadlines
- `GET /api/deadlines/overdue` - Get overdue deadlines
- `POST /api/deadlines/{id}/complete` - Mark deadline as done
- `PUT /api/deadlines/{id}` - Update deadline
- `DELETE /api/deadlines/{id}` - Delete deadline

### 📊 Reports (`/api/reports`)
- `GET /api/reports/dashboard` - Get quick summary
- `GET /api/reports/cases` - Get detailed report
- `GET /api/reports/cases/status/{status}` - Get cases by status
- `GET /api/reports/cases/lawyer/{name}` - Get cases by lawyer

## 📝 Example Usage

### 1. Create a New Case

**POST** `/api/cases`

```json
{
  "caseNumber": "CASE-2024-001",
  "title": "Smith vs Johnson",
  "description": "Contract dispute case",
  "lawyerName": "John Anderson",
  "courtName": "Superior Court",
  "dateFiled": "2024-01-15T00:00:00Z",
  "status": "Active",
  "parties": "Alice Smith (Plaintiff), Bob Johnson (Defendant)"
}
```

### 2. Add a Hearing

**POST** `/api/cases/1/hearings`

```json
{
  "date": "2024-02-15T00:00:00Z",
  "time": "10:30:00",
  "location": "Courtroom 3A",
  "type": "Initial Hearing",
  "notes": "First hearing to review case"
}
```

### 3. Add a Deadline

**POST** `/api/cases/1/deadlines`

```json
{
  "dueDate": "2024-02-10T00:00:00Z",
  "description": "Submit evidence documents",
  "priority": "High",
  "notes": "All documents must be ready before hearing"
}
```

### 4. Get Dashboard Summary

**GET** `/api/reports/dashboard`

**Response:**
```json
{
  "totalCases": 5,
  "activeCases": 3,
  "hearingsThisWeek": 2,
  "deadlinesThisWeek": 1,
  "overdueDeadlines": 0,
  "recentActivity": [
    "New case created: CASE-2024-001",
    "New case created: CASE-2024-002"
  ]
}
```

## 🗄️ Database

The API automatically creates a **SQL Server database** with these tables:

- **Cases** - Stores case information
- **Hearings** - Stores hearing schedules
- **Deadlines** - Stores important deadlines

**Sample data is automatically added** when you first run the app!

## 🎓 Perfect for Learning

This API is designed to be **super easy to understand** because:

1. **Simple Models** - No complex relationships
2. **Clear Names** - Everything is named obviously
3. **Basic Operations** - Standard CRUD (Create, Read, Update, Delete)
4. **Good Comments** - Every method is explained
5. **Error Handling** - Friendly error messages
6. **Swagger UI** - Test everything in your browser

## 🔧 Configuration

Edit `appsettings.json` to change database connection:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=SimpleLegalCaseDb;Trusted_Connection=true"
  }
}
```

## 📖 How to Explain This API

### For Non-Technical People:
*"This is like a digital filing cabinet for law firms. Instead of paper files, everything is stored in a computer database. Lawyers can add new cases, schedule court dates, set reminders for important deadlines, and get reports on their workload."*

### For Technical People:
*"This is a RESTful Web API built with ASP.NET Core 8. It uses Entity Framework for data access with SQL Server. The architecture follows a simple 3-layer pattern: Controllers handle HTTP requests, Models represent data, and DbContext manages database operations."*

### Key Concepts Demonstrated:
1. **REST API Design** - Standard HTTP methods (GET, POST, PUT, DELETE)
2. **Database Relationships** - One-to-many (Case → Hearings, Case → Deadlines)
3. **CRUD Operations** - Create, Read, Update, Delete
4. **Data Transfer Objects (DTOs)** - Separate request/response models
5. **Dependency Injection** - DbContext injected into controllers
6. **Error Handling** - Try-catch blocks with meaningful messages
7. **API Documentation** - Swagger/OpenAPI integration

## 🎯 Business Value

This API solves real problems for law firms:

- **Organization** - Keep all case info in one place
- **Scheduling** - Never miss a court hearing
- **Deadlines** - Track important dates and avoid missing them
- **Reporting** - See workload and case status at a glance
- **Efficiency** - Faster than paper-based systems

## 🚀 Next Steps

To make this production-ready, you could add:

- **Authentication** - Login system
- **Authorization** - Role-based access
- **Validation** - More input checking
- **Logging** - Better error tracking
- **Testing** - Unit and integration tests
- **Deployment** - Cloud hosting setup

---

**🎉 That's it! You now have a simple, working Legal Case Management API that's easy to understand and explain to anyone!**