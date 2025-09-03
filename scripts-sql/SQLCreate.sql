USE DB_WS_IMOB;
GO

CREATE TABLE Users (
    UserId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Name VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL UNIQUE,
    RG VARCHAR(20) NOT NULL,
    IssuingAuthority VARCHAR(50) NOT NULL,
    RGIssuingState VARCHAR(2) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    MaritalStatus VARCHAR(50) NOT NULL CHECK (MaritalStatus IN ('Single', 'Married', 'Divorced', 'Widowed', 'Legally Separated', 'Stable Union')),
    Role VARCHAR(50) NOT NULL, CHECK (Role IN ('Corretor', 'Administrativo', 'Financeiro', 'SuperUsuario')),
    Nationality VARCHAR(50) NOT NULL,
    Avatar VARCHAR(255),
    Status VARCHAR(20) DEFAULT 'active',
    MustChangePassword BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CreatedBy VARCHAR(100) NOT NULL,
    UpdatedAt DATETIME DEFAULT GETDATE(),
    UpdatedBy VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Persons (
    PersonId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Name VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL UNIQUE,
    RG VARCHAR(20) NOT NULL,
    IssuingAuthority VARCHAR(50) NOT NULL,
    RGIssuingState VARCHAR(2) NOT NULL,
    MaritalStatus VARCHAR(50) NOT NULL CHECK (MaritalStatus IN ('Single', 'Married', 'Divorced', 'Widowed', 'Legally Separated', 'Stable Union')),
    Nationality VARCHAR(50) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CreatedBy VARCHAR(100) NOT NULL,
    UpdatedAt DATETIME DEFAULT GETDATE(),
    UpdatedBy VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Addresses (
    AddressId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(20) NOT NULL CHECK (EntityType IN ('User', 'Person')), -- Identifica se é User ou Person
    EntityId UNIQUEIDENTIFIER NOT NULL, -- FK dinâmica que aponta para UserId ou PersonId
    Street VARCHAR(100) NOT NULL,
    Number VARCHAR(20) NOT NULL,
    AdditionalData VARCHAR(255),
    Neighborhood VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(2) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    IsActive BIT DEFAULT 1
);
GO

CREATE TABLE Phones (
    PhoneId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(20) NOT NULL CHECK (EntityType IN ('User', 'Person')), -- Identifica se é User ou Person
    EntityId UNIQUEIDENTIFIER NOT NULL, -- FK dinâmica que aponta para UserId ou PersonId
    Type VARCHAR(20) NOT NULL CHECK (Type IN ('mobile', 'home', 'work')),
    Number VARCHAR(20) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    IsActive BIT DEFAULT 1
);
GO

CREATE TABLE Emails (
    EmailId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(20) NOT NULL CHECK (EntityType IN ('User', 'Person')), -- Identifica se é User ou Person
    EntityId UNIQUEIDENTIFIER NOT NULL, -- FK dinâmica que aponta para UserId ou PersonId
    Type VARCHAR(20) NOT NULL CHECK (Type IN ('personal', 'work')),
    Email VARCHAR(100) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    IsActive BIT DEFAULT 1
);
GO