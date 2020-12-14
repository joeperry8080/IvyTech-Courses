USE WideWorldImporters
GO
DBCC FREEPROCCACHE;
DECLARE @packagetypeid INT = 1;
EXEC [report] @packagetypeid;
GO