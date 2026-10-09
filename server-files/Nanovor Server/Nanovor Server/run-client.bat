@echo off
rem Launches the game client that is already repointed at 127.0.0.1:8443.
rem Start run-server.bat FIRST and wait for "running on port 8443".
cd /d "%~dp0Nanovor"
echo Launching Nanovor client from: %CD%
start "" "Nanovor.exe"
