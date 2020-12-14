/*************************************************************************
Script to restore WideWorldImporters database for DBMS 150 final project.

Steps:
1 - restore db from lab file location
2 - run configuration application to update db to support SQL Server Enterprise
3 - execute procedure to prepare db for data loading
4 - execute procedure to load data based on variables
5 - execute procedure to reset db for normal operation

*/
use master;
go

restore database wideworldimporters from disk = 'c:\sql_sample_databases\wideworldimporters-full.bak' with
move 'wwi_primary' to 'c:\sql_sample_databases\wideworldimporters.mdf',
move 'wwi_userdata' to 'c:\sql_sample_databases\wideworldimporters_userdata.ndf',
move 'wwi_log' to 'c:\sql_sample_databases\wideworldimporters.ldf',
move 'wwi_inmemory_data_1' to 'c:\sql_sample_databases\wideworldimporters_inmemory_data_1',
stats=5
go

use wideworldimporters;
go

set nocount on;

exec application.configuration_configureforenterpriseedition
go

exec dataloadsimulation.configuration_applydataloadsimulationprocedures;
go

--default is current date -1 month for start, and current date for end_in
--must be int value can be neg or pos
declare @date_count int = -1


declare @start_in char(8) = (select convert(char(8),dateadd(mm,@date_count,getdate()),112));
declare @end_in char(8) = (select convert(char(8),getdate(),112));

exec dataloadsimulation.dailyprocesstocreatehistory 
    @startdate = @start_in,
    @enddate = @end_in,
    @averagenumberofcustomerordersperday = 60,
    @saturdaypercentageofnormalworkday = 50,
    @sundaypercentageofnormalworkday = 0,
    @updatecustomfields = 1,
    @issilentmode = 1,
    @aredatesprinted = 1;
go