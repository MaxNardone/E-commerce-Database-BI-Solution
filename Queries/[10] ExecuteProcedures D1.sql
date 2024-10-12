USE AssignmentPart1
GO

EXEC prCreateOrderGroup
    @OrderNumber = 'OR\28112023\01',
    @OrderCreateDate = '2023-11-28',
    @CustomerCityId = 12345;

Select *
From dbo.OrderGroup
where ordernumber = 'OR\28112023\01'

EXEC prCreateOrderGroup
    @OrderNumber = 'OR\27112023\01',
    @OrderCreateDate = '2023-11-27',
    @CustomerCityId = 25465;

EXEC prCreateOrderItem
    @OrderNumber = 'OR\27112023\01',
    @OrderItemNumber = 'OR\27112023\01\1',
    @ProductGroup = 'Bedtime',
	@ProductCode = '23685',
	@VariantCode = '00347526',
	@Quantity = 1,
	@UnitPrice = 14.99

EXEC prCreateOrderItem
    @OrderNumber = 'OR\27112023\01',
    @OrderItemNumber = 'OR\27112023\01\2',
    @ProductGroup = 'Christmas Sale',
	@ProductCode = '22166',
	@VariantCode = '00150615',
	@Quantity = 3,
	@UnitPrice = 4.99

Select *
From dbo.OrderGroup
where ordernumber = 'OR\27112023\01'

Select *
From dbo.OrderItem
where ordernumber = 'OR\27112023\01'


select @@TRANCOUNT 


----------Testing Data-------------
EXEC prCreateOrderGroup
    @OrderNumber = 'OR\29112023\99',
    @OrderCreateDate = '2023-11-29',
    @CustomerCityId = 25465;

--Check if the last 2 digits of the OrderNumber are between 1 and 99 --THIS SHOULD FAIL
EXEC prCreateOrderGroup
    @OrderNumber = 'OR\29112023\200',
    @OrderCreateDate = '2023-11-29',
    @CustomerCityId = 25465;

--Check if the date in OrderNumber matches the OrderCreateDate --THIS SHOULD FAIL
EXEC prCreateOrderGroup
    @OrderNumber = 'OR\20112023\99',
    @OrderCreateDate = '2023-11-29',
    @CustomerCityId = 25465;
