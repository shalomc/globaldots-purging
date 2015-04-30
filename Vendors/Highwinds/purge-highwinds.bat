@echo off
@setlocal

:: Sample usage: 
:: purge-highwinds.bat  http://dynamic.highwinds.cdn.test.danidin.net/index.html

:: Set User, Password and account variables from config file

:: Set auth variables from config file
set ConfigFile=Highwinds-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 

:: Set auth variables from config file
set PATH=%PATH%;..\..\common
@call source %ConfigFile%


set URL=%1
set OAUTHendpoint=https://striketracker3.highwinds.com/auth/token
set APIendpoint=https://striketracker3.highwinds.com/api/v1

:: Log into HW
FOR /F "tokens=* usebackq" %%a IN (`curl -s  -H "Accept: application/json" -X POST -d "grant_type=password&username=%Usr%&password=%Passw%"  %OAUTHendpoint%  `) DO (
	set OAUTH=%%a
	)

set OAUTH=%OAUTH:"=~%

FOR /F "tokens=2,4,6,8 delims={}:,~ " %%a IN ("%OAUTH%") DO (
	set access_token=%%a
	set token_type=%%b
	set expires_in=%%c
	set refresh_token=%%d
	)
set PurgeJSON={ ""list"": [ { ""url"": ""%URL%"", ""recursive"": ""false"" } ] }

curl -s -X POST -H "Authorization: Bearer %access_token%" -H "Accept: application/json" -H "Content-type: application/json" -d "%PurgeJSON%" %APIendpoint%/accounts/%account%/purge


:finish
echo.

