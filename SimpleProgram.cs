using Microsoft.EntityFrameworkCore;
using LegalCaseManagement.SimplifiedData;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container - Simple setup
builder.Services.AddControllers();

// Add database - Simple SQL Server connection
builder.Services.AddDbContext<SimpleDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add Swagger for API documentation
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "Simple Legal Case Management API",
        Version = "v1",
        Description = "A simple and easy-to-understand API for managing legal cases"
    });
});

// Add CORS to allow frontend connections
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Add logging
builder.Services.AddLogging();

var app = builder.Build();

// Configure the HTTP request pipeline - Simple setup
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Legal Case Management API V1");
        c.RoutePrefix = string.Empty; // Makes Swagger UI available at root URL
    });
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

// Create database if it doesn't exist - Simple database setup
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<SimpleDbContext>();
    try
    {
        context.Database.EnsureCreated(); // Creates database and tables automatically
        Console.WriteLine("Database created successfully!");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error creating database: {ex.Message}");
    }
}

Console.WriteLine("🚀 Legal Case Management API is running!");
Console.WriteLine("📖 Visit https://localhost:7000 for Swagger documentation");
Console.WriteLine("📊 API Base URL: https://localhost:7000/api");

app.Run();