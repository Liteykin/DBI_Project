// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace aether_db.Models
{
    public partial class UserPreference
    {
        [Key]
        public int UserID { get; set; }
        [Required]
        [StringLength(255)]
        [Unicode(false)]
        public string Language { get; set; }
        [Required]
        [StringLength(255)]
        [Unicode(false)]
        public string Timezone { get; set; }
        [Required]
        [StringLength(255)]
        [Unicode(false)]
        public string Theme { get; set; }

        [ForeignKey("UserID")]
        [InverseProperty("UserPreference")]
        public virtual User User { get; set; }
    }
}