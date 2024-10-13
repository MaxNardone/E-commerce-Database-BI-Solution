USE AssignmentPart1
GO

--------Delete Procedure for Debugging Purpose

IF OBJECT_ID('prCreateOrderItem', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE prCreateOrderItem;
END