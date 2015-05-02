@echo on
@setlocal

:: Sample usage: 
:: 		purge-leaseweb ZoneID  "regular-expression"
:: 

php -f purge-leaseweb.php %*

:finish
echo.
