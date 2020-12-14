IF DB_NAME() != 'WideWorldImporters' 
USE WideWorldImporters
SET NOCOUNT ON
GO

DBCC FREEPROCCACHE;
ALTER DATABASE current SET QUERY_STORE CLEAR ALL;
ALTER DATABASE current SET AUTOMATIC_TUNING (FORCE_LAST_GOOD_PLAN = OFF);
GO

DROP PROCEDURE IF EXISTS [dbo].[report]
GO
CREATE PROCEDURE [dbo].[report] (@packagetypeid int)
AS
BEGIN
	SELECT AVG([UnitPrice] * [Quantity] - [TaxRate])
	FROM [Sales].[OrderLines]
	WHERE [PackageTypeID] = @packagetypeid;
END;
GO
