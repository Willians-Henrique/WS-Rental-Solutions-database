USE DB_PROPERTY;
GO


CREATE TABLE TB_PROPERTY_TYPES (
    PropertyTypeId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Name VARCHAR(100) UNIQUE NOT NULL
);
GO

INSERT INTO TB_PROPERTY_TYPES (Name) VALUES 
    ('Casa Terrea'),
    ('Sobrado'),
    ('Apartamento'),
    ('Sala Comercial'),
    ('Ponto Comercial'),
    ('Sitio'),
    ('Chacara');
GO

CREATE TABLE TB_PROPERTIES (
    PropertyId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PropertyTypeId UNIQUEIDENTIFIER FOREIGN KEY REFERENCES TB_PROPERTY_TYPES(PropertyTypeId), 
    Street VARCHAR(100) NOT NULL,
    Number VARCHAR(20) NOT NULL,
    AdditionalData VARCHAR(255),
    Neighborhood VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(2) NOT NULL,
    Country VARCHAR(50) NOT NULL
);
GO

CREATE TABLE TB_PROPERTIES_OWNERS (
    PropertyOwnerId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PropertyId UNIQUEIDENTIFIER FOREIGN KEY REFERENCES TB_PROPERTIES(PropertyId),
    PersonId UNIQUEIDENTIFIER NOT NULL,
    PercentegeOwnership DECIMAL(5,2) NOT NULL CHECK (PercentegeOwnership >= 0 AND PercentegeOwnership <= 100),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CreatedBy VARCHAR(100) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    IsActive BIT DEFAULT 1
);
GO