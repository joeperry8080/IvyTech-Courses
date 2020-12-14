@ECHO OFF

SETLOCAL
SET SCENARIONAME=Regression

IF "%1"=="" (
  @ECHO Warning: SQLSERVER env var undefined - assuming a default SQL instance. 
  SET SQLSERVER=.
) ELSE (
  SET SQLSERVER=%1
)

REM ========== Setup ========== 
@ECHO %date% %time% - Starting scenario %SCENARIONAME%...
@ECHO %date% %time% - %SCENARIONAME%...
sqlcmd.exe -S%SQLSERVER% -E -dWideWorldImporters -ooutput\Regression.out -iRegression.sql %NULLREDIRECT%

