USE AssignmentPart1
GO

--SETTING STATISTICS ON
SET STATISTICS IO ON;
--Then press CTRL+M to activate Execution Plan

--CHECK CLUSTERED KEYS
SELECT 
    i.name AS IndexName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.type_desc AS IndexType
FROM 
    sys.indexes i
INNER JOIN 
    sys.objects o ON i.object_id = o.object_id
WHERE 
    i.type_desc = 'CLUSTERED'
    AND o.type = 'U' -- U represents user tables
ORDER BY 
    TableName, IndexName;


--CODE FOR FK CHECK
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTableName,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumnName
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
ORDER BY 
    TableName, ForeignKeyName;

	--end of it


--Before
SELECT p.Name, SUM(i.Quantity * v.Price) AS TotalSales
FROM OrderGroup g
JOIN OrderItem i ON g.OrderNumber = i.OrderNumber
JOIN ProductVariant v ON i.VariantCode = v.VariantCode
JOIN Product p ON v.ProductCode = p.ProductCode
GROUP BY p.ProductCode, p.Name;


CREATE CLUSTERED INDEX Clus_Index_Ord ON OrderItem (OrderNumber);
CREATE INDEX Index_ProdName ON Product (ProductCode) INCLUDE (Name);
CREATE INDEX Index_OrdVarQuan ON OrderItem (OrderNumber, VariantCode) INCLUDE (Quantity);
CREATE INDEX Index_ProdVarProdPrice ON ProductVariant (VariantCode, ProductCode) INCLUDE (Price);


--AFTER
SELECT p.Name, SUM(i.Quantity * v.Price) AS TotalSales
FROM OrderGroup g
JOIN OrderItem i ON g.OrderNumber = i.OrderNumber
JOIN ProductVariant v ON i.VariantCode = v.VariantCode
JOIN Product p ON v.ProductCode = p.ProductCode
GROUP BY p.ProductCode, p.Name;




-------------------------------------------------------------------------------
---------------------------------City

--BEFORE
SELECT l.City, SUM(g.SavedTotal) AS CitySales
FROM OrderGroup g
JOIN Customer c ON g.CustomerCityId = c.ID
JOIN Location l ON c.City = l.City
GROUP BY l.City;

CREATE INDEX Index_Loc_Cit ON Location (City);
CREATE INDEX Index_OrdGroup_2 ON OrderGroup (CustomerCityId) INCLUDE (SavedTotal);


--AFTER
SELECT l.City, SUM(g.SavedTotal) AS CitySales
FROM OrderGroup g
JOIN Customer c ON g.CustomerCityId = c.ID
JOIN Location l ON c.City = l.City
GROUP BY l.City;

--------------------------------------------------------------------------------------------
-----------------------------CUSTOMER

--Total Sales per Customer ---
--Before
SELECT c.ID,c.FirstName,c.LastName,SUM(g.SavedTotal) AS CustomerSales
FROM OrderGroup g
JOIN Customer c ON g.CustomerCityId = c.ID
GROUP BY c.ID,c.FirstName,c.LastName






--After
SELECT c.ID,c.FirstName,c.LastName,SUM(g.SavedTotal) AS CustomerSales
FROM OrderGroup g
JOIN Customer c ON g.CustomerCityId = c.ID
GROUP BY c.ID,c.FirstName,c.LastName


