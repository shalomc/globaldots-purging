@echo off
@setlocal

:: Sample usage: 
:: purge-ngenix-batch list-of-urls-to-purge.txt
:: This file is set up for a specific property tag, the property tag variable can also be set to be passed as an input

set ConfigFile=Ngenix-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 

set URL_List=%1

if not exist %URL_List% (
    echo The URL List file: %URL_List% does not exist. Aborting purge!
	goto finish
) 




set PATH=%PATH%;..\..\common
@call source %ConfigFile%

set APIendpoint=https://api.ngenix.net

curl -s  -X POST  -u "%User%:%Password%" -H "Accept: application/json" -H "Content-Type: text/plain" -d @%URL_List%  %APIendpoint%/v1/commands/purge/%Property_Tag%

:finish
echo.
