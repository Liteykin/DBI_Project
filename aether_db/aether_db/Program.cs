using System.ComponentModel.Design;
using aether_db.Models;

using var context = new aether_db.Models.aether_dbContext();


var users = new List<aether_db.Models.User>();
for (int i = 0; i < 10; i++)
{
    var user = new aether_db.Models.User()
    {
        Username = "user" + i,
        Name = "User " + i,
        Email = "user" + i + "@example.com",
        Password = "password" + i,
        Number =  "+" + i + i + i + i + i + i + i + i + i,
        created_at = DateTime.Now,
        last_login = DateTime.Now
    };
    users.Add(user);
}

context.Users.AddRange(users);
context.SaveChanges();
var deviceTypes = new List<aether_db.Models.DeviceType>();
deviceTypes.Add(new aether_db.Models.DeviceType { DeviceType1 = "Smartphone" });
deviceTypes.Add(new aether_db.Models.DeviceType { DeviceType1 = "Tablet" });
deviceTypes.Add(new aether_db.Models.DeviceType { DeviceType1 = "Laptop" });
context.DeviceTypes.AddRange(deviceTypes);

var userPreferences = new List<aether_db.Models.UserPreference>();
foreach (var user in users)
{
    var preference = new aether_db.Models.UserPreference()
    {
        UserID = user.UserID,
        Language = "en",
        Timezone = "UTC",
        Theme = "light"
    };
    userPreferences.Add(preference);
}

context.UserPreferences.AddRange(userPreferences);
context.SaveChanges();
var devices = new List<aether_db.Models.Device>();
var rnd = new Random();
foreach (var user in users)
{
    var device = new aether_db.Models.Device()
    {
        UserID = user.UserID,
        DeviceType = deviceTypes.ElementAt(rnd.Next(0, 3)).DeviceTypeID,
        DeviceName = "Device " + user.UserID,
    };
    devices.Add(device);
}

context.Devices.AddRange(devices);
context.SaveChanges();
var commands = new List<aether_db.Models.Command>();
foreach (var device in devices)
{
    var command = new aether_db.Models.Command()
    {
        UserID = device.UserID,
        DeviceID = device.DeviceID,
        CommandText = "",
        CommandResponse = "Command executed successfully",
    };
    commands.Add(command);
}

context.Commands.AddRange(commands);
context.SaveChanges();