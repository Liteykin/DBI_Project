USE master;

DECLARE @DBNAME AS NVARCHAR(MAX) = N'Chatflow';

IF DB_ID(@DBNAME) IS NOT NULL
BEGIN
    EXEC(N'ALTER DATABASE ' + @DBNAME + N' SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE ' + @DBNAME + N';');
END;

EXEC(N'CREATE DATABASE ' + @DBNAME + N';');
GO

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
    CONSTRAINT [FK_User_Supervisor] FOREIGN KEY (SupervisorId) REFERENCES [User](UserId),
    CONSTRAINT [CHK_UserBirthDate] CHECK (BirthDate <= GETDATE())
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
    Text VARCHAR(1000) NOT NULL,
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

CREATE VIEW SupervisorHierarchy AS
SELECT
    U1.UserId AS UserId,
    U1.Username AS UserName,
    U1.FirstName AS UserFirstName,
    U1.LastName AS UserLastName,
    U2.UserId AS SupervisorId,
    U2.Username AS SupervisorUsername,
    U2.FirstName AS SupervisorFirstName,
    U2.LastName AS SupervisorLastName
FROM
    [User] U1
LEFT JOIN
    [User] U2 ON U1.SupervisorId = U2.UserId;

INSERT INTO [User] (SupervisorId, Username, FirstName, LastName, Password, Email, BirthDate, SignUpDate, Attributes)
VALUES
(NULL, 'jdoe', 'John', 'Doe', 'password1', 'jdoe@example.com', '1980-01-01', GETDATE(), NULL),
(NULL, 'asmith', 'Alice', 'Smith', 'password2', 'asmith@example.com', '1985-01-01', GETDATE(), NULL),
(1, 'mjones', 'Michael', 'Jones', 'password3', 'mjones@example.com', '1990-01-01', GETDATE(), NULL),
(2, 'sjohnson', 'Sarah', 'Johnson', 'password4', 'sjohnson@example.com', '1995-01-01', GETDATE(), NULL);

SELECT * FROM [User];

SELECT * FROM SupervisorHierarchy;