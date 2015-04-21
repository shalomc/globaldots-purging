@echo off
@setlocal

:: Sample usage: 
:: purge-edgecast.bat http://wpc.121X0.edgecastcdn.net/00121X0/ecfolder/testapi.txt
:: This file is set up for a specific platform, the Platform variable can also be set to be passed as an input

set ConfigFile=Edgecast-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 
set PATH=%PATH%;..\..\common
@call source %ConfigFile%

set APIendpoint=https://api.edgecast.com
set FlashMediaStreaming=2
set HTTPLarge=3
set HTTPSmall=8
set ADN=14

set URL=%1
set Platform=%HTTPLarge%

curl -s  -H "Authorization: tok:%MyToken%" -H "Accept: application/json" -H "Content-Type: application/json" -X PUT -d "{ ""MediaPath"":""%URL%"", ""MediaType"":%Platform% }"  %APIendpoint%/v2/mcc/customers/%HEX%/edge/purge  

:finish
echo.
