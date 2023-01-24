IF EXISTS (SELECT * FROM sys.databases WHERE name = 'aether_db')
BEGIN
    DROP DATABASE aether_db
END

CREATE DATABASE aether_db
USE aether_db

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY (1,1),
    Username VARCHAR(255) NOT NULL UNIQUE,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Number VARCHAR(255) NOT NULL UNIQUE,
    created_at DATETIME,
    last_login DATETIME
);

CREATE TABLE UserPreferences (
    UserID INT PRIMARY KEY,
    Language VARCHAR(255) NOT NULL,
    Timezone VARCHAR(255) NOT NULL,
    Theme VARCHAR(255) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Devices (
    DeviceID INT PRIMARY KEY DEFAULT NEWID(),
    UserID INT NOT NULL,
    DeviceType INT NOT NULL,
    DeviceName VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (DeviceType) REFERENCES DeviceTypes(DeviceTypeID)
);

CREATE TABLE Commands (
    CommandID INT PRIMARY KEY IDENTITY (1,1),
    UserID INT NOT NULL,
    DeviceID INT NOT NULL,
    CommandText VARCHAR(255),
    CommandResponse VARCHAR(255) NOT NULL,
    Timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (DeviceID) REFERENCES Devices(DeviceID)
);

CREATE TABLE DeviceTypes (
    DeviceTypeID INT PRIMARY KEY IDENTITY (1,1),
    DeviceType VARCHAR(255)
);
