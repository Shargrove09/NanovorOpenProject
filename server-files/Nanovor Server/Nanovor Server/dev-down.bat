@echo off
rem Stops the server gracefully (saves every account first).
cd /d "%~dp0"
node tools\dev.js down
pause
