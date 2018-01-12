@ECHO OFF
:: Test Proxy Connection and get External IP
:: 
:: Part of https://github.com/servidge/snowflakes

echo "Please Type your Username"
set /p USERMANE=
echo "Please Type your Password"
set /p PASSWORT=

echo Your username is %USERMANE%
echo Your password is %PASSWORT%

for %%x in (
10.10.11.15:8080
10.11.11.15:8080
pr001.emea1.example.com:8080
pr001.emea2.example.com:8080
pr001.apac1.example.com:8080
pr001.apac2.example.com:8080
pr001.ncsa1.example.com:8080
pr002.ncsa1.example.com:8080
127.0.0.1:3128
	) do (
	echo Proxy Test: %%x
	REM "debug -v " 
	REM curl -v -U %USERMANE%:%PASSWORT% -x %%x --url  http://api.ipify.org
	curl --proxy-ntlm -U %USERMANE%:%PASSWORT% -x %%x  --url http://api.ipify.org
	echo.
)

pause
