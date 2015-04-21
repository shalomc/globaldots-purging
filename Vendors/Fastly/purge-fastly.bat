@echo off
@setlocal
:: Purge a single URL
:: Sample usage: Provide the URL
::   purge-fastly.bat http://fastly.cdn.test.danidin.net/index.html

:: To setup an X-Purge-Auth shared secret, see this resource 
::  http://my.globaldots.com/knowledgebase.php?action=displayarticle&id=21


set ConfigFile=Fastly-config.txt

:: Set auth variables from config file
if not exist %ConfigFile% (
    echo Configuration file: %ConfigFile% does not exist. Aborting purge!
	goto finish
) 



:: Set auth variables from config file
set PATH=%PATH%;..\..\common
@call source %ConfigFile%

set URL=%1

curl -s -X PURGE %URL% -H "X-Purge-Auth: %X_Purge_Auth%" 

:finish
echo.
