USE AssignmentPart1
GO

-- Create procedure must be at the top of query

-- Create the prCreateOrderItem stored procedure into OrderItem
CREATE PROCEDURE prCreateOrderItem
    @OrderNumber nvarchar(32),
    @OrderItemNumber nvarchar(32),
    @ProductGroup nvarchar(128),
	@ProductCode nvarchar(255),
	@VariantCode nvarchar(255),
	@Quantity int,
	@UnitPrice money
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
		IF @Quantity <= 0 
			THROW 50101, 'Error: Quantity cannot be smaller than 1.', 1;

		-- ordernumber is found in ordergroup (Checked)
		IF NOT EXISTS (SELECT 1 FROM OrderGroup WHERE OrderNumber = @OrderNumber)
			THROW 50102, 'Error: Order Number does not exist.', 1;

		--ordernumber is substring of orderItemnumber
		DECLARE @SubStringOrderItemNumber NVARCHAR(14)
		SET @SubStringOrderItemNumber = SUBSTRING(@OrderItemNumber, 1, 14);
		IF NOT @OrderNumber = @SubStringOrderItemNumber
			THROW 50103, 'OrderItemNumber should consist OrderNumber.', 1;

		-- variant code is found in productVariant
		IF NOT EXISTS (SELECT 1 FROM ProductVariant WHERE VariantCode = @VariantCode)
			THROW 50104, 'Error: Variant Code does not exist.', 1;

		-- Check if VariantCode exists in ProductVariant table and verify UnitPrice
		DECLARE @ExistingPrice money;
		SELECT @ExistingPrice = Price
		FROM ProductVariant
		WHERE VariantCode = @VariantCode;

		IF (@ExistingPrice IS NOT NULL) AND (@ExistingPrice <> @UnitPrice)
			THROW 50105, 'Error: UnitPrice does not match existing price for the VariantCode.', 1;

		--Check if @VariantCode and @ProductGroup are found into the ProductMapping table.
		IF NOT EXISTS (
		SELECT 1
		FROM ProductMapping
		WHERE VariantCode = @VariantCode AND ProductGroup = @ProductGroup)
			THROW 50106,  'Error: VariantCode or ProductCode not found into ProductMapping', 1;
			
        INSERT INTO dbo.OrderItem(OrderItemNumber, OrderNumber, VariantCode , ProductGroup , Quantity , LineItemTotal)
        VALUES (@OrderItemNumber, @OrderNumber, @VariantCode ,@ProductGroup ,@Quantity , @Quantity*@UnitPrice  );

		UPDATE dbo.ordergroup
		SET TotalLineItems = TotalLineItems + @Quantity
		WHERE Ordernumber = @ordernumber;
		

		UPDATE dbo.ordergroup
		SET SavedTotal = SavedTotal + @Quantity*@UnitPrice
		WHERE Ordernumber = @ordernumber;
		

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END
GO


