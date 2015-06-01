@echo on
@setlocal

:: Sample usage: 
:: 		purge-hibernia ZoneID  "regular-expression"
:: 

FOR /F "tokens=* usebackq" %%a IN (`php -f purge-hibernia.php `) DO (
	set OAUTH=%%a
	)

set BASE_URL=https://portal.hiberniacdn.com
:: set BASE_URL=http://echo.httpkit.com
set ACTION=api/purges.json
:: php -f purge-hibernia.php %* > token.txt
curl -i -H "Authorization: Bearer %OAUTH%" -H "content-type: application/json" -d @hibernia.json -X POST "%BASE_URL%/%ACTION%" 
:: curl -i -H "Authorization: Bearer %OAUTH%"  -d "site_id=98" -d "site_id=98" -X POST "%BASE_URL%/%ACTION%"

:: logout not working
:: curl -i -H "Authorization: Bearer %OAUTH%" -H "content-type: application/json" -d "{""bearer_token"":""%OAUTH%""}" -X POST "%BASE_URL%/%ACTION%" 
:: curl -i -H "Authorization: Bearer %OAUTH%" -d "bearer_token=%OAUTH%" -X POST "%BASE_URL%/%ACTION%" 

set ACTION=api/logout.json
curl -i -H "Authorization: Bearer %OAUTH%" -X POST "%BASE_URL%/%ACTION%" 
:finish
echo.
