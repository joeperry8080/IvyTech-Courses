@ECHO OFF

SETLOCAL
SET SCENARIONAME=Auto_Tuning

IF "%1"=="" (
  @ECHO Warning: SQLSERVER env var undefined - assuming a default SQL instance. 
  SET SQLSERVER=.
) ELSE (
  SET SQLSERVER=%1
)

REM ========== Setup ========== 
@ECHO %date% %time% - Starting scenario %SCENARIONAME%...
@ECHO %date% %time% - %SCENARIONAME%...
sqlcmd.exe -S%SQLSERVER% -E -dWideWorldImporters -ooutput\Auto_tune.out -iAuto_tune.sql %NULLREDIRECT%

REM ========== Start ========== 
REM Start expensive query
@ECHO %date% %time% - Starting foreground queries...
SET /A NUMTHREADS=%NUMBER_OF_PROCESSORS%*3
REM CALL ..\common\StartN.cmd /N %NUMTHREADS% /C ..\common\loop.cmd sqlcmd.exe -S%SQLSERVER% -E -iProblemQuery.sql -dWideWorldImporters  2^> output\ProblemQuery.err > NUL
.\ostress -E -iProblemQuery.sql -n%NUMTHREADS% -r10000 -q -S%SQLSERVER%

REM @ECHO %date% %time% - Press ENTER to end the scenario. 
REM pause %NULLREDIRECT%
@ECHO %date% %time% - Shutting down...


REM ========== Cleanup ========== 
sqlcmd.exe -S%SQLSERVER% -E -ddWideWorldImporters  -iCleanup.sql %NULLREDIRECT%
CALL ..\common\Cleanup.cmd %SQLSERVER%