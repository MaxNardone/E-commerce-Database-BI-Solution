USE AssignmentPart1
GO

---------------------------------------------------------------
--Modify older tables' names
-- Rename OrderItem to OrderItem1
EXEC sp_rename 'dbo.OrderItem', 'OrderItem1';
-- Rename Product to Product1
EXEC sp_rename 'dbo.Product', 'Product1';
--Can give warning messages
-----------------------------------------------------------------
--QUERY TO CREATE NEW TABLES

-- Create Location table
CREATE TABLE Location (
    City NVARCHAR(255) PRIMARY KEY,
    County NVARCHAR(255) NOT NULL,
    Region NVARCHAR(255) NOT NULL,
    Country NVARCHAR(255) NOT NULL
);

-- Create Customer table
CREATE TABLE Customer (
    ID BIGINT PRIMARY KEY,
    City NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(255) NOT NULL ,
    LastName NVARCHAR(255)NOT NULL,
    DateRegistered DATETIME CHECK (DateRegistered <= GETDATE()), -- Constraint for date not in the future
    FOREIGN KEY (City) REFERENCES Location(City)
);


-- Create Orders table
CREATE TABLE OrderGroup (
    OrderNumber NVARCHAR(32) PRIMARY KEY CHECK (OrderNumber LIKE 'OR\%\%'),
    CustomerCityId BIGINT NOT NULL,
    OrderCreateDate DATETIME CHECK (OrderCreateDate <= GETDATE()), -- Constraint for date not in the future
    OrderStatusCode INT NOT NULL CHECK (OrderStatusCode IN (0, 1, 2, 3, 4)) DEFAULT (0),
    BillingCurrency NVARCHAR(3) NOT NULL DEFAULT('GBP'),
    TotalLineItems INT NOT NULL CHECK (TotalLineItems >= 0) DEFAULT (0),
    SavedTotal MONEY NOT NULL CHECK (SavedTotal >= 0) DEFAULT (0),
    FOREIGN KEY (CustomerCityId) REFERENCES Customer(ID)

);

-- Create Product table
CREATE TABLE Product (
    ProductCode NVARCHAR(255) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Features NVARCHAR(3600),
    Description NVARCHAR(3600)
);

-- Create ProductVariant table
CREATE TABLE ProductVariant (
    VariantCode NVARCHAR(255) PRIMARY KEY,
    ProductCode NVARCHAR(255) NOT NULL,
    Cup NVARCHAR(255),
    Size NVARCHAR(255),
    LegLength NVARCHAR(255),
    Colour NVARCHAR(255),
    Price MONEY NOT NULL CHECK (Price >= 0), -- Constraint cannot be below zero
    FOREIGN KEY (ProductCode) REFERENCES Product(ProductCode)
);

-- Create ProductMapping table
CREATE TABLE ProductMapping (
    ProductGroup NVARCHAR(128) NOT NULL,
    VariantCode NVARCHAR(255) NOT NULL,
    PRIMARY KEY (ProductGroup, VariantCode),
    FOREIGN KEY (VariantCode) REFERENCES ProductVariant(VariantCode)
);

-- Create OrderItem table
CREATE TABLE OrderItem (
    OrderItemNumber NVARCHAR(32) PRIMARY KEY NONCLUSTERED CHECK (OrderItemNumber LIKE 'OR\%\%'),
    OrderNumber NVARCHAR(32) NOT NULL CHECK (OrderNumber LIKE 'OR\%\%'),
    VariantCode NVARCHAR(255) NOT NULL,
    ProductGroup NVARCHAR(128) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    LineItemTotal MONEY NOT NULL CHECK (LineItemTotal >= 0), -- Constraint cannot be below zero,
    FOREIGN KEY (OrderNumber) REFERENCES OrderGroup(OrderNumber),
    FOREIGN KEY (VariantCode) REFERENCES ProductVariant(VariantCode),
    FOREIGN KEY (ProductGroup,VariantCode) REFERENCES ProductMapping(ProductGroup,VariantCode)
);


------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--END OF QUERY TO CREATE TABLES
