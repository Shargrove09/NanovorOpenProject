@echo off
cd /d "%~dp0"

rem Fresh log each run. node appends (>>) so the live-tail window
rem below does not get truncated out from under it.
type nul > server.log

echo ============================================================
echo   Nanovor Server
echo.
echo   Log file   : %CD%\server.log
echo   A second window will open showing the live log.
echo.
echo   Press Ctrl+C in THIS window to stop the server.
echo ============================================================
echo.

start "Nanovor server log" powershell -NoProfile -Command "Get-Content -LiteralPath '%CD%\server.log' -Wait -Tail 40"

node NanoServ.js >> server.log 2>&1

echo.
echo Server stopped.
pause
