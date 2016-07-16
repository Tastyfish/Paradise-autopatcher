@echo off
@title SERVER WATCHDOG
call config.bat
call bin\findbyond.bat

echo Welcome to the start server watch dog script, This will start the server and make sure it stays running. To continue, press any key or wait 60 seconds.
timeout 60

if not exist gamedata\data\logs\runtimes mkdir gamedata\data\logs\runtimes\

:START
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
set CUR_DATE=%mydate%_%mytime%
cls
echo Watch Dog FOR %CUR_DATE%.
echo Server Running. Watching for server exits.
start /WAIT /ABOVENORMAL "" dreamdaemon.exe gamefolder\%PROJECTNAME%.dmb -port %PORT% -trusted -close -log "data\logs\runtimes\runtime-%CUR_DATE%.log"
cls
echo Watch Dog.
echo Server exit detected. Restarting in 60 seconds.
timeout 60

goto :START
