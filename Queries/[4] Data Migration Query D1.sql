USE AssignmentPart1
GO

-- Migrating data from CustomerCity to Location
INSERT INTO Dbo.Location (City, County, Region, Country)
SELECT DISTINCT City, County, Region, Country
FROM Dbo.CustomerCity;

-- Migrating data from CustomerCity to Customer
INSERT INTO Dbo.Customer (Id, Gender, FirstName, LastName , DateRegistered,City)
SELECT DISTINCT Id, Gender, FirstName, LastName , DateRegistered,City
FROM Dbo.CustomerCity;

-- Migrating data from OrderItem1 to OrderGroup
INSERT INTO Dbo.OrderGroup(OrderNumber, CustomerCityId, OrderCreateDate, OrderStatusCode, BillingCurrency)
SELECT DISTINCT OrderNumber, CustomerCityId, OrderCreateDate, OrderStatusCode, BillingCurrency
FROM Dbo.OrderItem1;
----------------------------------------------------

--ADDED TO MIGRATION TO CALCULATE THE TOTAL LINE ITEM
UPDATE dbo.ordergroup
SET totallineitems = (
    SELECT SUM(Quantity)
    FROM dbo.orderitem1
    WHERE dbo.orderitem1.ordernumber = dbo.ordergroup.ordernumber
    GROUP BY ordernumber
);

--ADDED TO MIGRATION TO CALCULATE THE TOTAL LINE ITEM
UPDATE dbo.ordergroup
SET savedtotal = (
    SELECT SUM(LineItemTotal)
    FROM dbo.orderitem1
    WHERE dbo.orderitem1.ordernumber = dbo.ordergroup.ordernumber
    GROUP BY ordernumber
);

-- from Product1 to Product
INSERT INTO Dbo.Product(ProductCode, Name, Features, Description)
SELECT DISTINCT ProductCode, Name, Features, Description
FROM Dbo.Product1;


-- Migrating from Product1 to ProductVariant
INSERT INTO Dbo.ProductVariant(VariantCode, ProductCode, Cup, Size, LegLength, Colour, Price)
SELECT DISTINCT VariantCode, ProductCode, Cup, Size, LegLength, Colour, Price
FROM Dbo.Product1;

-- Migrating from Product1 to ProductMapping
INSERT INTO Dbo.ProductMapping(ProductGroup, VariantCode)
SELECT DISTINCT ProductGroup, VariantCode
FROM Dbo.Product1;

-- Migrating from OrderItem1 to OrderItem
INSERT INTO Dbo.OrderItem(OrderItemNumber, OrderNumber, VariantCode, ProductGroup, Quantity, LineItemTotal)
SELECT DISTINCT OrderItemNumber, OrderNumber, VariantCode, ProductGroup, Quantity, LineItemTotal
FROM Dbo.OrderItem1;

