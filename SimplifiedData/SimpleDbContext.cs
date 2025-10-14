using Microsoft.EntityFrameworkCore;
using LegalCaseManagement.SimplifiedModels;

namespace LegalCaseManagement.SimplifiedData
{
    /// <summary>
    /// Simple Database Context - easy to understand
    /// </summary>
    public class SimpleDbContext : DbContext
    {
        public SimpleDbContext(DbContextOptions<SimpleDbContext> options) : base(options)
        {
        }

        // Database tables
        public DbSet<Case> Cases { get; set; }
        public DbSet<Hearing> Hearings { get; set; }
        public DbSet<Deadline> Deadlines { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Simple relationships
            modelBuilder.Entity<Hearing>()
                .HasOne(h => h.Case)
                .WithMany(c => c.Hearings)
                .HasForeignKey(h => h.CaseId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Deadline>()
                .HasOne(d => d.Case)
                .WithMany(c => c.Deadlines)
                .HasForeignKey(d => d.CaseId)
                .OnDelete(DeleteBehavior.Cascade);

            // Make case number unique
            modelBuilder.Entity<Case>()
                .HasIndex(c => c.CaseNumber)
                .IsUnique();

            // Seed some sample data for testing
            SeedData(modelBuilder);
        }

        private void SeedData(ModelBuilder modelBuilder)
        {
            // Sample cases
            modelBuilder.Entity<Case>().HasData(
                new Case
                {
                    Id = 1,
                    CaseNumber = "CASE-2024-001",
                    Title = "Smith vs. Johnson Contract Dispute",
                    Description = "Dispute over service contract terms and payment",
                    LawyerName = "John Anderson",
                    CourtName = "Superior Court of Justice",
                    DateFiled = new DateTime(2024, 1, 15),
                    Status = "Active",
                    Parties = "Alice Smith (Plaintiff), Bob Johnson (Defendant)",
                    CreatedAt = DateTime.UtcNow
                },
                new Case
                {
                    Id = 2,
                    CaseNumber = "CASE-2024-002",
                    Title = "Davis Property Rights Case",
                    Description = "Property boundary dispute between neighbors",
                    LawyerName = "Sarah Williams",
                    CourtName = "District Court",
                    DateFiled = new DateTime(2024, 2, 1),
                    Status = "Pending",
                    Parties = "Michael Davis (Plaintiff), City Council (Defendant)",
                    CreatedAt = DateTime.UtcNow
                }
            );

            // Sample hearings
            modelBuilder.Entity<Hearing>().HasData(
                new Hearing
                {
                    Id = 1,
                    CaseId = 1,
                    Date = DateTime.UtcNow.AddDays(15),
                    Time = new TimeSpan(10, 30, 0),
                    Location = "Courtroom 3A",
                    Type = "Initial Hearing",
                    Notes = "First hearing to review case details",
                    Status = "Scheduled",
                    CreatedAt = DateTime.UtcNow
                }
            );

            // Sample deadlines
            modelBuilder.Entity<Deadline>().HasData(
                new Deadline
                {
                    Id = 1,
                    CaseId = 1,
                    DueDate = DateTime.UtcNow.AddDays(10),
                    Description = "Submit initial evidence documents",
                    Priority = "High",
                    IsCompleted = false,
                    Notes = "All evidence must be submitted before hearing",
                    CreatedAt = DateTime.UtcNow
                },
                new Deadline
                {
                    Id = 2,
                    CaseId = 2,
                    DueDate = DateTime.UtcNow.AddDays(7),
                    Description = "File motion for summary judgment",
                    Priority = "Medium",
                    IsCompleted = false,
                    CreatedAt = DateTime.UtcNow
                }
            );
        }
    }
}