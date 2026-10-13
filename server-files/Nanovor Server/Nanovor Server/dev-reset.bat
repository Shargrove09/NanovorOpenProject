@echo off
rem Resets the test account 'n' to its pristine baseline. Works whether or not
rem the server is running. Re-login in the client afterwards.
cd /d "%~dp0"
node tools\dev.js account reset n %*
pause
