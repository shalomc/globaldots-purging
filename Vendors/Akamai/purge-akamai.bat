:: Purge single URL
:: Sample usage: 
:: purge-akamai.bat http://your-url/

@echo off
@setlocal

set ConfigFile=Akamai-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 

:: Set User and Password variables from config file
set PATH=%PATH%;..\..\common
@call source %ConfigFile%

set URL=%1

set QUEUE=default
set APIpoint=api.ccu.akamai.com
curl -v -X POST https://%APIpoint%/ccu/v2/queues/%QUEUE% -H "Content-Type:application/json" -d "{ ""objects"":[""%URL%""]}" -u "%User%:%Password%"

:finish
echo.
