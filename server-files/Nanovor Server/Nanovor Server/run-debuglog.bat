@echo off
rem Opens the game's own debug console. The client broadcasts its internal
rem narration over a LocalConnection channel; this SWF is the viewer for it.
rem
rem Run order:
rem   1. run-server.bat
rem   2. run-debuglog.bat   <-- this (start it BEFORE the client)
rem   3. run-client.bat
rem
rem Watch for lines from <<ServiceRequestBrokerParser>> and
rem <<GameEngineGameServiceController>> -- they say what the client
rem decided to do with the Game Service IP and port.
cd /d "%~dp0"
echo Opening DebugLog viewer...
start "" "flashplayer_32_sa.exe" "DebugLog.swf"
