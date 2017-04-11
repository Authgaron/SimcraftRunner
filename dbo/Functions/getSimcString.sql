CREATE FUNCTION [dbo].[getSimcString]
(@itemSlot NVARCHAR (MAX), @itemLink NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [Theorycrafting].[UserDefinedFunctions].[getSimcString]

