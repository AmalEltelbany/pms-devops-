-- PMS Database Initialization Script
-- Creates all required tables for Site, Booking, and Invoice services

-- =============================================
-- PMS_Site Database Tables
-- =============================================
USE PMS_Site;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Sites')
BEGIN
    CREATE TABLE Sites (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Path NVARCHAR(MAX) NOT NULL,
        NameEn NVARCHAR(100) NOT NULL,
        NameAr NVARCHAR(100) NOT NULL,
        PricePerHour DECIMAL(18,2) NULL,
        IntegrationCode NVARCHAR(100) NOT NULL,
        NumberOfSlots INT NULL,
        IsLeaf BIT NOT NULL,
        ParentId UNIQUEIDENTIFIER NULL,
        CONSTRAINT FK_Sites_Sites_ParentId FOREIGN KEY (ParentId) REFERENCES Sites(Id)
    );
    CREATE UNIQUE INDEX IX_Sites_IntegrationCode ON Sites(IntegrationCode);
    CREATE UNIQUE INDEX IX_Sites_NameAr ON Sites(NameAr);
    CREATE UNIQUE INDEX IX_Sites_NameEn ON Sites(NameEn);
    CREATE INDEX IX_Sites_ParentId ON Sites(ParentId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Polygons')
BEGIN
    CREATE TABLE Polygons (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        SiteId UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT FK_Polygons_Sites_SiteId FOREIGN KEY (SiteId) REFERENCES Sites(Id) ON DELETE CASCADE
    );
    CREATE UNIQUE INDEX IX_Polygons_Name ON Polygons(Name);
    CREATE INDEX IX_Polygons_SiteId ON Polygons(SiteId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PolygonPoints')
BEGIN
    CREATE TABLE PolygonPoints (
        Longitude DECIMAL(9,6) NOT NULL,
        Latitude DECIMAL(9,6) NOT NULL,
        PolygonId UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT PK_PolygonPoints PRIMARY KEY (PolygonId, Longitude, Latitude),
        CONSTRAINT FK_PolygonPoints_Polygons_PolygonId FOREIGN KEY (PolygonId) REFERENCES Polygons(Id) ON DELETE CASCADE
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '__EFMigrationsHistory')
BEGIN
    CREATE TABLE __EFMigrationsHistory (
        MigrationId NVARCHAR(150) NOT NULL PRIMARY KEY,
        ProductVersion NVARCHAR(32) NOT NULL
    );
    INSERT INTO __EFMigrationsHistory VALUES ('20251221180434_InitialMigration', '8.0.22');
END
GO

-- =============================================
-- PMS_Booking Database Tables
-- =============================================
USE PMS_Booking;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Sites')
BEGIN
    CREATE TABLE Sites (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Path NVARCHAR(MAX) NOT NULL,
        NameEn NVARCHAR(100) NOT NULL,
        NameAr NVARCHAR(100) NOT NULL,
        PricePerHour DECIMAL(18,2) NOT NULL,
        IntegrationCode NVARCHAR(MAX) NOT NULL,
        NumberOfSolts INT NOT NULL
    );
    CREATE UNIQUE INDEX IX_Sites_NameAr ON Sites(NameAr);
    CREATE UNIQUE INDEX IX_Sites_NameEn ON Sites(NameEn);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Tickets')
BEGIN
    CREATE TABLE Tickets (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        SiteName NVARCHAR(100) NOT NULL,
        PlateNumber NVARCHAR(20) NOT NULL,
        PhoneNumber NVARCHAR(15) NOT NULL,
        BookingFrom DATETIME2 NOT NULL,
        BookingTo DATETIME2 NOT NULL,
        TotalPrice DECIMAL(18,2) NOT NULL,
        SiteId UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT FK_Tickets_Sites_SiteId FOREIGN KEY (SiteId) REFERENCES Sites(Id) ON DELETE CASCADE
    );
    CREATE INDEX IX_Tickets_SiteId ON Tickets(SiteId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '__EFMigrationsHistory')
BEGIN
    CREATE TABLE __EFMigrationsHistory (
        MigrationId NVARCHAR(150) NOT NULL PRIMARY KEY,
        ProductVersion NVARCHAR(32) NOT NULL
    );
    INSERT INTO __EFMigrationsHistory VALUES ('20251221180434_InitialMigration', '8.0.22');
END
GO

-- =============================================
-- PMS_Invoice Database Tables
-- =============================================
USE PMS_Invoice;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Tickets')
BEGIN
    CREATE TABLE Tickets (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        SiteName NVARCHAR(100) NOT NULL,
        PlateNumber NVARCHAR(20) NOT NULL,
        PhoneNumber NVARCHAR(15) NOT NULL,
        BookingFrom DATETIME2 NOT NULL,
        BookingTo DATETIME2 NOT NULL,
        TotalPrice DECIMAL(18,2) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Invoices')
BEGIN
    CREATE TABLE Invoices (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        HtmlDocumentPath NVARCHAR(MAX) NOT NULL,
        TaxAmount DECIMAL(18,2) NOT NULL,
        TotalAmountBeforeTax DECIMAL(18,2) NOT NULL,
        TotalAmountAfterTax DECIMAL(18,2) NOT NULL,
        TicketSerialNumber NVARCHAR(MAX) NOT NULL,
        TicketId UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT FK_Invoices_Tickets_TicketId FOREIGN KEY (TicketId) REFERENCES Tickets(Id) ON DELETE CASCADE
    );
    CREATE UNIQUE INDEX IX_Invoices_TicketId ON Invoices(TicketId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '__EFMigrationsHistory')
BEGIN
    CREATE TABLE __EFMigrationsHistory (
        MigrationId NVARCHAR(150) NOT NULL PRIMARY KEY,
        ProductVersion NVARCHAR(32) NOT NULL
    );
    INSERT INTO __EFMigrationsHistory VALUES ('20251221180434_InitialMigration', '8.0.22');
END
GO

PRINT 'All database tables created successfully!';
GO
