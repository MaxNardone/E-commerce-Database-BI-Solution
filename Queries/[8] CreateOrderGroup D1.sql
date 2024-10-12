USE AssignmentPart1
GO

-- Create procedure must be at the top of query

-- Create the prCreateOrderGroup stored procedure
CREATE PROCEDURE prCreateOrderGroup
    @OrderNumber NVARCHAR(32),
    @OrderCreateDate DATETIME,
    @CustomerCityId BIGINT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
		IF NOT (@OrderNumber LIKE 'OR\%\%') 
			THROW 50001, 'Error: OrderNumber should be in the format of OR\DDMMYYYY\XX', 1;
			
		IF EXISTS (SELECT 1 FROM OrderGroup WHERE OrderNumber = @OrderNumber)
			THROW 50002, 'Error: Duplicted Order Number.', 1;	

		IF @OrderCreateDate > GETDATE() OR @OrderCreateDate < '2000-06-01'
			THROW 50003, 'Error: Invalid OrderCreateDate, cannot be in the future or before June 2000.', 1;


		-- Extract the date part from OrderNumber and compare with OrderCreateDate
		DECLARE @OrderNumberDate NVARCHAR(8);
        SET @OrderNumberDate = SUBSTRING(@OrderNumber, 4, 8);

        IF @OrderNumberDate <> FORMAT(@OrderCreateDate, 'ddMMyyyy')
            THROW 50004, 'Error: OrderNumber date does not match OrderCreateDate.', 1;

		-- Extract the sequential number from the OrderNumber 
		DECLARE @SequentialNumber INT;
        SET @SequentialNumber = CAST(SUBSTRING(@OrderNumber, 13, LEN(@OrderNumber) - 12) AS INT);

		IF @SequentialNumber NOT BETWEEN 1 AND 99
			THROW 50005, 'Error: SeqeuntialNumber does not lie in range 1 to 99.', 1;

		IF NOT EXISTS (SELECT 1 FROM dbo.customer WHERE ID = @CustomerCityId)
			THROW 50006, 'Error: Customer does not exist.', 1;

		--Check if the sequential number is incremental
		DECLARE @MaxSequentialNumber INT;
		-- Find the maximum sequential number for the given date
		SELECT @MaxSequentialNumber = MAX(CAST(RIGHT(OrderNumber, 2) AS INT))
		FROM OrderGroup
		WHERE LEFT(OrderNumber, 12) = LEFT(@OrderNumber, 12)

		IF @SequentialNumber <> ISNULL(@MaxSequentialNumber, 0) + 1
			THROW 50022, 'Error: Sequential number should be greater than the last Sequential number by 1. ', 1;

        INSERT INTO dbo.OrderGroup(OrderNumber, OrderCreateDate, CustomerCityId)
        VALUES (@OrderNumber, @OrderCreateDate, @CustomerCityId);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
		
        THROW;
    END CATCH;
END
GO