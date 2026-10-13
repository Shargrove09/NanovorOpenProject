@echo off
rem Runs the test suites and prints one pass/fail summary.
cd /d "%~dp0"
node tools\dev.js smoke
pause
