USE master;
GO
BEGIN
    DECLARE @DBNAME AS VARCHAR(MAX) = 'Chatflow'
    IF EXISTS(SELECT * FROM sys.databases WHERE Name = @DBNAME)
    BEGIN
        EXEC('ALTER DATABASE ' + @DBNAME + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');
        EXEC('DROP DATABASE ' + @DBNAME);
    END;
    EXEC('CREATE DATABASE ' + @DBNAME);
END;
USE Chatflow;
GO

CREATE TABLE [User](
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    SupervisorId INT,
    Username VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    SignUpDate DATETIME NOT NULL,
    Attributes VARCHAR(MAX),
    CONSTRAINT [UQ_Email] UNIQUE (Email),
    CONSTRAINT [FK_User_Supervisor] FOREIGN KEY (SupervisorId) REFERENCES [User](UserId)
);

CREATE TABLE [Category](
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    CONSTRAINT [UQ_CategoryName] UNIQUE (CategoryName)
);

CREATE TABLE [Room](
    RoomId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryId INT NOT NULL,
    RoomName VARCHAR(50) NOT NULL,
    RoomCreationDate DATETIME NOT NULL,
    CONSTRAINT [FK_Room_Category] FOREIGN KEY (CategoryId) REFERENCES [Category](CategoryId),
    CONSTRAINT [UQ_Room_Category_RoomName] UNIQUE (CategoryId, RoomName)
);

CREATE TABLE [UserRoom](
    UserId INT NOT NULL,
    RoomId INT NOT NULL,
    UserRoomJoinDate DATETIME NOT NULL,
    PRIMARY KEY (UserId, RoomId),
    CONSTRAINT [FK_UserRoom_User] FOREIGN KEY (UserId) REFERENCES [User](UserId),
    CONSTRAINT [FK_UserRoom_Room] FOREIGN KEY (RoomId) REFERENCES [Room](RoomId)
);

CREATE TABLE [Message](
    MessageId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    RoomId INT NOT NULL,
    Text TEXT NOT NULL,
    Timestamp DATETIME NOT NULL,
    CONSTRAINT [FK_Message_User] FOREIGN KEY (UserId) REFERENCES [User](UserId),
    CONSTRAINT [FK_Message_Room] FOREIGN KEY (RoomId) REFERENCES [Room](RoomId)
);

CREATE TABLE [ReactionType](
    ReactionId INT IDENTITY(1,1) PRIMARY KEY,
    ReactionType VARCHAR(50) NOT NULL,
    CONSTRAINT [UQ_ReactionType] UNIQUE (ReactionType)
);

CREATE TABLE [MessageReaction](
    MessageReactionId INT IDENTITY(1,1) PRIMARY KEY,
    MessageId INT NOT NULL,
    UserId INT NOT NULL,
    ReactionId INT NOT NULL,
    Timestamp DATETIME NOT NULL,
    CONSTRAINT [FK_MessageReaction_Message] FOREIGN KEY (MessageId) REFERENCES [Message](MessageId),
    CONSTRAINT [FK_MessageReaction_User] FOREIGN KEY (UserId) REFERENCES [User](UserId),
    CONSTRAINT [FK_MessageReaction_ReactionType] FOREIGN KEY (ReactionId) REFERENCES [ReactionType](ReactionId)
);


ALTER TABLE [User]
ADD CONSTRAINT [CHK_UserBirthDate]
CHECK (BirthDate <= GETDATE());

ALTER TABLE [User]
ADD SupervisorId INT,
CONSTRAINT [FK_User_Supervisor] FOREIGN KEY (SupervisorId) REFERENCES [User](UserId);
