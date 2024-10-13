USE AssignmentPart1
GO
--------Delete Procedure for Debugging Purpose

IF OBJECT_ID('prCreateOrderGroup', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE prCreateOrderGroup;
END