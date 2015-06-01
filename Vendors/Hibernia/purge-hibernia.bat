@echo on
@setlocal

:: Sample usage: 
:: 		purge-hibernia SiteID  "URL"
:: 

php -f purge-hibernia.php %* 
:finish
echo.
