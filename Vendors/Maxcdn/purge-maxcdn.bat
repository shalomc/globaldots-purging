@echo off
@setlocal
:: Purge single URL
:: Sample usage: 
:: purge-maxcdn.bat  http://maxcdn.cdn.test.danidin.net/index.html
:: The zone id is hardcoded,  placed in the config file instead, 
::    or the script modified to be passed as an argument

:: Prerequisites:
::   the maxpurge tool, https://github.com/MaxCDN/maxcli

set ConfigFile=MaxCDNconfig.yml

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 

:: Set all credentials from yaml file. 
:: They can also be passed as parameters to the tool
:: See https://github.com/MaxCDN/maxcli/tree/master/maxpurge
:: The zone can also be placed in the yaml file, if you only have one to work with. 

set URL=%1
set zone=12345

maxpurge --config %ConfigFile% --zone %zone% --file "%URL%" 

:finish
echo.
