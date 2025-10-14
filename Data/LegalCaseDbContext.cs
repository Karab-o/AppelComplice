using Microsoft.EntityFrameworkCore;
using LegalCaseManagement.Models;

namespace LegalCaseManagement.Data
{
    /// <summary>
    /// Entity Framework DbContext for Legal Case Management System
    /// </summary>
    public class LegalCaseDbContext : DbContext
    {
        public LegalCaseDbContext(DbContextOptions<LegalCaseDbContext> options) : base(options)
        {
        }

        // DbSets for all entities
        public DbSet<Case> Cases { get; set; }
        public DbSet<Lawyer> Lawyers { get; set; }
        public DbSet<Court> Courts { get; set; }
        public DbSet<Party> Parties { get; set; }
        public DbSet<CaseParty> CaseParties { get; set; }
        public DbSet<Hearing> Hearings { get; set; }
        public DbSet<Deadline> Deadlines { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure Case entity
            modelBuilder.Entity<Case>(entity =>
            {
                entity.HasKey(e => e.CaseId);
                entity.Property(e => e.CaseNumber).IsRequired().HasMaxLength(50);
                entity.Property(e => e.Title).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Description).HasMaxLength(1000);
                entity.Property(e => e.Status).IsRequired().HasMaxLength(50).HasDefaultValue("Active");
                entity.Property(e => e.Outcome).HasMaxLength(500);
                entity.Property(e => e.IsActive).HasDefaultValue(true);
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");

                // Index for case number (should be unique)
                entity.HasIndex(e => e.CaseNumber).IsUnique();

                // Configure relationships
                entity.HasOne(e => e.AssignedLawyer)
                      .WithMany(l => l.Cases)
                      .HasForeignKey(e => e.AssignedLawyerId)
                      .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Court)
                      .WithMany(c => c.Cases)
                      .HasForeignKey(e => e.CourtId)
                      .OnDelete(DeleteBehavior.Restrict);
            });

            // Configure Lawyer entity
            modelBuilder.Entity<Lawyer>(entity =>
            {
                entity.HasKey(e => e.LawyerId);
                entity.Property(e => e.FirstName).IsRequired().HasMaxLength(100);
                entity.Property(e => e.LastName).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Phone).HasMaxLength(20);
                entity.Property(e => e.BarNumber).HasMaxLength(50);
                entity.Property(e => e.Specialization).HasMaxLength(100);
                entity.Property(e => e.IsActive).HasDefaultValue(true);
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");

                // Index for email (should be unique)
                entity.HasIndex(e => e.Email).IsUnique();
                entity.HasIndex(e => e.BarNumber).IsUnique();
            });

            // Configure Court entity
            modelBuilder.Entity<Court>(entity =>
            {
                entity.HasKey(e => e.CourtId);
                entity.Property(e => e.Name).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Type).HasMaxLength(100);
                entity.Property(e => e.Address).HasMaxLength(300);
                entity.Property(e => e.City).HasMaxLength(100);
                entity.Property(e => e.State).HasMaxLength(50);
                entity.Property(e => e.ZipCode).HasMaxLength(20);
                entity.Property(e => e.Phone).HasMaxLength(20);
                entity.Property(e => e.IsActive).HasDefaultValue(true);
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            });

            // Configure Party entity
            modelBuilder.Entity<Party>(entity =>
            {
                entity.HasKey(e => e.PartyId);
                entity.Property(e => e.FirstName).IsRequired().HasMaxLength(100);
                entity.Property(e => e.LastName).IsRequired().HasMaxLength(100);
                entity.Property(e => e.PartyType).HasMaxLength(50);
                entity.Property(e => e.Email).HasMaxLength(200);
                entity.Property(e => e.Phone).HasMaxLength(20);
                entity.Property(e => e.Address).HasMaxLength(300);
                entity.Property(e => e.City).HasMaxLength(100);
                entity.Property(e => e.State).HasMaxLength(50);
                entity.Property(e => e.ZipCode).HasMaxLength(20);
                entity.Property(e => e.IsActive).HasDefaultValue(true);
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            });

            // Configure CaseParty junction table
            modelBuilder.Entity<CaseParty>(entity =>
            {
                entity.HasKey(e => e.CasePartyId);
                entity.Property(e => e.Role).IsRequired().HasMaxLength(50);
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");

                // Configure many-to-many relationship
                entity.HasOne(e => e.Case)
                      .WithMany(c => c.CaseParties)
                      .HasForeignKey(e => e.CaseId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(e => e.Party)
                      .WithMany(p => p.CaseParties)
                      .HasForeignKey(e => e.PartyId)
                      .OnDelete(DeleteBehavior.Cascade);

                // Composite index to prevent duplicate case-party combinations
                entity.HasIndex(e => new { e.CaseId, e.PartyId, e.Role }).IsUnique();
            });

            // Configure Hearing entity
            modelBuilder.Entity<Hearing>(entity =>
            {
                entity.HasKey(e => e.HearingId);
                entity.Property(e => e.Location).HasMaxLength(200);
                entity.Property(e => e.HearingType).HasMaxLength(100);
                entity.Property(e => e.Remarks).HasMaxLength(500);
                entity.Property(e => e.Status).HasMaxLength(50).HasDefaultValue("Scheduled");
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");

                // Configure relationships
                entity.HasOne(e => e.Case)
                      .WithMany(c => c.Hearings)
                      .HasForeignKey(e => e.CaseId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(e => e.Court)
                      .WithMany(c => c.Hearings)
                      .HasForeignKey(e => e.CourtId)
                      .OnDelete(DeleteBehavior.SetNull);
            });

            // Configure Deadline entity
            modelBuilder.Entity<Deadline>(entity =>
            {
                entity.HasKey(e => e.DeadlineId);
                entity.Property(e => e.Description).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Priority).HasMaxLength(50).HasDefaultValue("Medium");
                entity.Property(e => e.IsCompleted).HasDefaultValue(false);
                entity.Property(e => e.Notes).HasMaxLength(500);
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");

                // Configure relationship
                entity.HasOne(e => e.Case)
                      .WithMany(c => c.Deadlines)
                      .HasForeignKey(e => e.CaseId)
                      .OnDelete(DeleteBehavior.Cascade);
            });

            // Seed data for testing
            SeedData(modelBuilder);
        }

        private void SeedData(ModelBuilder modelBuilder)
        {
            // Seed Lawyers
            modelBuilder.Entity<Lawyer>().HasData(
                new Lawyer
                {
                    LawyerId = 1,
                    FirstName = "John",
                    LastName = "Smith",
                    Email = "john.smith@lawfirm.com",
                    Phone = "555-0101",
                    BarNumber = "BAR001",
                    Specialization = "Criminal Law",
                    CreatedAt = DateTime.UtcNow
                },
                new Lawyer
                {
                    LawyerId = 2,
                    FirstName = "Sarah",
                    LastName = "Johnson",
                    Email = "sarah.johnson@lawfirm.com",
                    Phone = "555-0102",
                    BarNumber = "BAR002",
                    Specialization = "Civil Law",
                    CreatedAt = DateTime.UtcNow
                }
            );

            // Seed Courts
            modelBuilder.Entity<Court>().HasData(
                new Court
                {
                    CourtId = 1,
                    Name = "Superior Court of Justice",
                    Type = "Superior",
                    Address = "123 Justice Blvd",
                    City = "Downtown",
                    State = "CA",
                    ZipCode = "90210",
                    Phone = "555-0201",
                    CreatedAt = DateTime.UtcNow
                },
                new Court
                {
                    CourtId = 2,
                    Name = "District Court",
                    Type = "District",
                    Address = "456 Court Street",
                    City = "Midtown",
                    State = "CA",
                    ZipCode = "90211",
                    Phone = "555-0202",
                    CreatedAt = DateTime.UtcNow
                }
            );

            // Seed Parties
            modelBuilder.Entity<Party>().HasData(
                new Party
                {
                    PartyId = 1,
                    FirstName = "Alice",
                    LastName = "Williams",
                    PartyType = "Individual",
                    Email = "alice.williams@email.com",
                    Phone = "555-0301",
                    Address = "789 Main Street",
                    City = "Downtown",
                    State = "CA",
                    ZipCode = "90210",
                    CreatedAt = DateTime.UtcNow
                },
                new Party
                {
                    PartyId = 2,
                    FirstName = "Bob",
                    LastName = "Davis",
                    PartyType = "Individual",
                    Email = "bob.davis@email.com",
                    Phone = "555-0302",
                    Address = "321 Oak Avenue",
                    City = "Uptown",
                    State = "CA",
                    ZipCode = "90212",
                    CreatedAt = DateTime.UtcNow
                }
            );
        }
    }
}