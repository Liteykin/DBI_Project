USE master;
GO
BEGIN
    DECLARE @DBNAME AS VARCHAR(MAX) = 'Chatflow'
    IF EXISTS(SELECT * FROM sys.databases WHERE Name = @DBNAME)
    BEGIN
        -- Disconnect all users and recreate database.
        EXEC('ALTER DATABASE ' + @DBNAME + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE');
        EXEC('DROP DATABASE ' + @DBNAME);
    END;
    EXEC('CREATE DATABASE ' + @DBNAME);
END;
USE Chatflow;
-- Change to your database name (USE does not allow variables)
GO

-- Create User table
CREATE TABLE [User](
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    UserFirstName VARCHAR(50) NOT NULL,
    UserLastName VARCHAR(50) NOT NULL,
    UserPassword VARCHAR(50) NOT NULL,
    UserEmail VARCHAR(50) NOT NULL,
    UserBirthDate DATE NOT NULL,
    UserSignUpDate DATETIME NOT NULL,
    CONSTRAINT [UQ_UserEmail] UNIQUE (UserEmail)
);

-- Create Category table
CREATE TABLE [Category](
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    CONSTRAINT [UQ_CategoryName] UNIQUE (CategoryName)
);

-- Create Room table
CREATE TABLE [Room](
    ChatRoomId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryId INT NOT NULL,
    ChatRoomName VARCHAR(50) NOT NULL,
    ChatRoomCreationDate DATETIME NOT NULL,
    CONSTRAINT [FK_Room_Category] FOREIGN KEY (CategoryId) REFERENCES [Category](CategoryId),
    CONSTRAINT [UQ_Room_Category_ChatRoomName] UNIQUE (CategoryId, ChatRoomName)
);

-- Create UserRoom table
CREATE TABLE [UserRoom](
    UserId INT NOT NULL,
    ChatRoomId INT NOT NULL,
    UserChatRoomJoinDate DATETIME NOT NULL,
    PRIMARY KEY (UserId, ChatRoomId),
    CONSTRAINT [FK_UserRoom_User] FOREIGN KEY (UserId) REFERENCES [User](UserId),
    CONSTRAINT [FK_UserRoom_Room] FOREIGN KEY (ChatRoomId) REFERENCES [Room](ChatRoomId)
);

-- Create Message table
CREATE TABLE [Message](
    MessageId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ChatRoomId INT NOT NULL,
    MessageText TEXT NOT NULL,
    MessageTimestamp DATETIME NOT NULL,
    CONSTRAINT [FK_Message_User] FOREIGN KEY (UserId) REFERENCES [User](UserId),
    CONSTRAINT [FK_Message_Room] FOREIGN KEY (ChatRoomId) REFERENCES [Room](ChatRoomId)
);

-- Create ReactionType table
CREATE TABLE [ReactionType](
    ReactionId INT IDENTITY(1,1) PRIMARY KEY,
    ReactionType VARCHAR(50) NOT NULL,
    CONSTRAINT [UQ_ReactionType] UNIQUE (ReactionType)
);

-- Create MessageReaction table
CREATE TABLE [MessageReaction](
    MessageReactionId INT IDENTITY(1,1) PRIMARY KEY,
    MessageId INT NOT NULL,
    UserId INT NOT NULL,
    ReactionId INT NOT NULL,
    ReactionTimestamp DATETIME NOT NULL,
    CONSTRAINT [FK_MessageReaction_Message] FOREIGN KEY (MessageId) REFERENCES [Message](MessageId),
    CONSTRAINT [FK_MessageReaction_User] FOREIGN KEY (UserId) REFERENCES [User](UserId),
    CONSTRAINT [FK_MessageReaction_ReactionType] FOREIGN KEY (ReactionId) REFERENCES [ReactionType](ReactionId)
);

-- Add CHECK constraint to ensure UserBirthDate is not in the future
ALTER TABLE [User]
ADD CONSTRAINT [CHK_UserBirthDate]
CHECK (UserBirthDate <= GETDATE());

-- Add CHECK