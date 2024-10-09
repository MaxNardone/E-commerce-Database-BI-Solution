USE AssignmentPart1
GO
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--JOIN FOR VERIFICATION
--------------------------------------------------------------------------------------------------------------

SET STATISTICS IO ON;


SELECT *
FROM Location AS L
JOIN Customer AS C ON L.City = C.City
JOIN OrderGroup AS O ON C.ID = O.CustomerCityId
JOIN OrderItem1 AS OI ON O.OrderNumber = OI.OrderNumber
JOIN ProductVariant AS PV ON OI.VariantCode = PV.VariantCode
JOIN ProductMapping AS PT ON OI.ProductGroup = PT.ProductGroup AND OI.VariantCode = PT.VariantCode
JOIN Product AS P ON PV.ProductCode = P.ProductCode;

--46041


--check
SELECT *
FROM Dbo.CustomerCity
--51992

SELECT *
FROM Location AS L
JOIN Customer AS C ON L.City = C.City
--51992


SELECT *
FROM Dbo.Product1
--4574

SELECT *
FROM ProductVariant AS PV
JOIN ProductMapping AS PT ON  PV.VariantCode = PT.VariantCode
JOIN Product AS P ON PV.ProductCode = P.ProductCode;
--4574


SELECT * 
FROM Dbo.OrderItem1
--46041
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--MIGRATION SUCCESSFUL
