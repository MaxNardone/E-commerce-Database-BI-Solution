USE AssignmentPart1
GO

--Counting each order status --
SELECT COUNT(*) AS Count
FROM dbo.OrderGroup
WHERE OrderStatusCode = 0

SELECT COUNT(*) AS Count
FROM dbo.OrderGroup
WHERE OrderStatusCode = 1

SELECT COUNT(*) AS Count
FROM dbo.OrderGroup
WHERE OrderStatusCode = 2

SELECT COUNT(*) AS Count
FROM dbo.OrderGroup
WHERE OrderStatusCode = 3

SELECT COUNT(*) AS Count
FROM dbo.OrderGroup
WHERE OrderStatusCode = 4


-- Percentages of total Orders --
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM OrderGroup)) AS Percentage
FROM dbo.OrderGroup
WHERE OrderstatusCode = 0;

SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM OrderGroup)) AS Percentage
FROM dbo.OrderGroup
WHERE OrderstatusCode = 1;

SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM OrderGroup)) AS Percentage
FROM dbo.OrderGroup
WHERE OrderstatusCode = 2;

SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM OrderGroup)) AS Percentage
FROM dbo.OrderGroup
WHERE OrderstatusCode = 3;

SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM OrderGroup)) AS Percentage
FROM dbo.OrderGroup
WHERE OrderstatusCode = 4;

-- Total Sales per order status code --
SELECT SUM(SavedTotal) AS 'Sales in $'
FROM dbo.OrderGroup
WHERE OrderStatusCode=2

-- Table Join --

SELECT DISTINCT p.Name
FROM OrderGroup g
JOIN OrderItem i ON g.OrderNumber = i.OrderNumber
JOIN ProductVariant v ON i.VariantCode = v.VariantCode
JOIN Product p ON v.ProductCode=p.ProductCode


-- Total Sales per Product ---
SELECT p.Name,SUM(i.Quantity*v.Price) AS TotalSales
FROM OrderGroup g
JOIN OrderItem i ON g.OrderNumber = i.OrderNumber
JOIN ProductVariant v ON i.VariantCode = v.VariantCode
JOIN Product p ON v.ProductCode=p.ProductCode
GROUP BY p.ProductCode,p.Name
ORDER BY TotalSales DESC


--Total Sales per Customer ---
SELECT c.ID,c.FirstName,c.LastName,SUM(g.SavedTotal) AS CustomerSales
FROM OrderGroup g
JOIN Customer c ON g.CustomerCityId = c.ID
GROUP BY c.ID,c.FirstName,c.LastName
ORDER BY CustomerSales DESC

--Total Sales Per City --
SELECT l.City,SUM(g.SavedTotal) AS CitySales
FROM OrderGroup g
JOIN Customer c ON g.CustomerCityId = c.ID
JOIN Location l ON c.City = l.City
GROUP BY l.City
ORDER BY CitySales DESC


SELECT *
FROM OrderGroup g
JOIN OrderItem i ON g.OrderNumber = i.OrderNumber
JOIN ProductVariant v ON i.VariantCode = v.VariantCode
JOIN Product p ON v.ProductCode=p.ProductCode