@echo on
@setlocal

:: Sample usage: 
:: purge-ngenix http://chopard-st.cdn.ngenix.net/test2.txt
:: This file is set up for a specific property tag, the property tag variable can also be set to be passed as an input

set ConfigFile=Ngenix-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 
set PATH=%PATH%;..\..\common
@call source %ConfigFile%

set APIendpoint=https://api.ngenix.net

set URL=%1

curl -v  -X POST  -u "%User%:%Password%" -H "Accept: application/json" -H "Content-Type: text/plain" -d "%URL%"  %APIendpoint%/v1/commands/purge/%Property_Tag%

:finish
echo.
