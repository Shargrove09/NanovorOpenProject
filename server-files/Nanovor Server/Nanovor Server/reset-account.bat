@echo off
rem Restores account 'n' to its pristine starting state, so the
rem new-user / "choose a Nanovor" flow can be re-tested from scratch.
rem Stop the server first -- it holds user data in memory and will
rem overwrite this file on shutdown.
cd /d "%~dp0"
if not exist "UserData.orig-backup\n.json" (
    echo ERROR: UserData.orig-backup\n.json not found.
    pause
    exit /b 1
)
copy /Y "UserData.orig-backup\n.json" "UserData\n.json" >nul
echo Account 'n' reset to starting state.
pause
