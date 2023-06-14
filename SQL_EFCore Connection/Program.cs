using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using Bogus;
using System.Linq;
using System.Text.Json;

namespace EFCoreAccess
{
    public class ChatflowContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<SupervisorHierarchyView> SupervisorHierarchy { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
            => options.UseSqlServer("Server=localhost,1433;Database=Chatflow;User Id=sa;Password=SqlServer2019;TrustServerCertificate=True;");

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>().ToTable("User");
            modelBuilder.Entity<SupervisorHierarchyView>().ToView("SupervisorHierarchy");
        }
    }

    public class User
    {
        public int UserId { get; set; }
        public int? SupervisorId { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public DateTime BirthDate { get; set; }
        public DateTime SignUpDate { get; set; }
        public string Attributes { get; set; }

        [ForeignKey("SupervisorId")]
        public User Supervisor { get; set; }
    }

    [Keyless]
    public class SupervisorHierarchyView
    {
        public int UserId { get; set; }
        public string? UserName { get; set; }
        public string? UserFirstName { get; set; }
        public string? UserLastName { get; set; }
        public int? SupervisorId { get; set; }
        public string? SupervisorUsername { get; set; }
        public string? SupervisorFirstName { get; set; }
        public string? SupervisorLastName { get; set; }
    }



    class Program
    {
        static void Main()
        {
            using (var context = new ChatflowContext())
            {
                // Check if the Users are already seeded
                if (!context.Users.Any())
                {
                    // Seed the User table
                    var users = new List<User>
                    {
                        new User { SupervisorId = null, Username = "jdoe", FirstName = "John", LastName = "Doe", Password = "password1", Email = "jdoe@example.com", BirthDate = new DateTime(1980, 1, 1), SignUpDate = DateTime.Now },
                        new User { SupervisorId = 1, Username = "asmith", FirstName = "Alice", LastName = "Smith", Password = "password2", Email = "asmith@example.com", BirthDate = new DateTime(1985, 1, 1), SignUpDate = DateTime.Now },
                    };
                    context.Users.AddRange(users);
                    context.SaveChanges();
                }

                var supervisorHierarchy = context.SupervisorHierarchy.ToList();
                foreach (var entry in supervisorHierarchy)
                {
                    string supervisorName = (entry.SupervisorFirstName ?? "No Supervisor") + " " + (entry.SupervisorLastName ?? "");
    
                    Console.WriteLine($"{entry.UserFirstName ?? "Unknown"} {entry.UserLastName ?? "User"} (Supervisor: {supervisorName.Trim()})");
                }
            }
        }
    }
}
