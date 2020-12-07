declare @date varchar(255)
/*
set @date = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters' 
		+ (SELECT cast(datepart(year, getdate()) as char(4)) + 
		cast(DATEPART(month, getdate()) as varchar(2)) + 
		cast(datepart(day, getdate()) as varchar(2)) +
		cast(datepart(hour, getdate()) as varchar(2)) +
		cast(datepart(minute, getdate()) as varchar(2))
		) + '.DIF';
*/
set @date = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters-' 
		+ (SELECT convert(varchar(10), getdate(), 112) +
		cast(datepart(hour, getdate()) as varchar(2))
		) + '.DIF'

--select @date

/*BACKUP DATABASE WideWorldImporters 
	TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters.BAK'
GO
*/
BACKUP DATABASE WideWorldImporters 
	TO DISK = @date WITH DIFFERENTIAL
GO