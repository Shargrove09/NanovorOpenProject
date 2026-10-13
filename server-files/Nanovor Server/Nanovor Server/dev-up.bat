@echo off
rem Starts the server (waits until it actually answers), then the DebugLog
rem viewer, then the client - in the order the client needs.
cd /d "%~dp0"
node tools\dev.js up %*
pause
