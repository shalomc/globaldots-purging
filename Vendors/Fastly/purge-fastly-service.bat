@echo off
@setlocal
:: Purge a whole site

:: Sample usage: Purge the entire site
::   purge-fastly-service.bat xyz9bpgo87jaTDEPx0pQH purge_all 

:: Sample usage: Purge a surrogate key
::   purge-fastly-service.bat xyz9bpgo87jaTDEPx0pQH key12 

set ConfigFile=Fastly-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 

:: Set auth variables from config file
set PATH=%PATH%;..\..\common
@call source %ConfigFile%

set site_id=%1
set Purge_Command=%2

set APIendpoint=https://api.fastly.com


IF /I "%Purge_Command%" == "purge_all"  (set PurgeString=purge_all) ELSE (set PurgeString=purge/%Purge_Command%)


curl -s -X POST %APIendpoint%/service/%site_id%/%PurgeString% -H "Fastly-Key: %Fastly_Key%" -H "Accept: application/json"


:finish
echo.
