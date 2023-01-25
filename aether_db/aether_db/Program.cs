using System;
using var context = new aether_db.Models.aether_dbContext();
var data = Console.ReadLine();
context.DeviceTypes.Add(new aether_db.Models.DeviceType { DeviceType1 = data });
context.SaveChanges();
Console.WriteLine(data);
