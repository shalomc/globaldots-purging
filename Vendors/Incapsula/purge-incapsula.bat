@echo off
@setlocal
:: Purge a single URL
:: Sample usage: Provide the site id AND the URL
::   purge-incapsula.bat 1529663 /index.html

:: Set auth variables from config file
set ConfigFile=Incapsula-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 

:: Set auth variables from config file
set PATH=%PATH%;..\..\common
@call source %ConfigFile%

set site_id=%1
set URLPath=%2

set APIendpoint=https://my.incapsula.com

curl -s -X POST -d "api_id=%api_id%" -d "api_key=%api_key%" -d "site_id=%site_id%" -d "resource_url=%URLPath%" -d "resource_pattern=equals" %APIendpoint%/api/prov/v1/sites/performance/purge

:finish
echo.
