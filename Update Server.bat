@echo off
@title Server Updater
set HOME = %USERPROFILE%
call config.bat
if exist updating.lk (
	echo ERROR! A current update script has been detected running.
	timeout 60
	exit /b 1
)
if exist rotating.lk (
	echo ERROR! A current map rotation operation has been detected running. IT IS STRONGLY RECOMMENDED YOU DO NOT UPDATE RIGHT NOW. if you know this is a mistake, and that the game server is not currently rotating the map:
	timeout 60
	exit /b 1
)
@del /F /Q rotating.lk >nul 2>nul
echo lock>updating.lk

rem if the first arg to nudge.py is not a channel, it is treated as the "source"
if not defined UPDATE_LOG_CHANNEL set UPDATE_LOG_CHANNEL="UPDATER"

call bin\updategit.bat
if %GIT_EXIT%==UNCHANGED (
	echo game up to date.
	@del updating.lk >nul 2>nul
	timeout 10
	exit /b 1
)

call ircbots.bat "Starting server update..." >nul 2>nul

if %GIT_EXIT% neq 0 (
	echo git pull failed. Aborting update
	call ircbots.bat "Git pull failed. Aborting update."
	@del updating.lk >nul 2>nul
	timeout 60
	exit /b 1
)
if defined PUSHCHANGELOGTOGIT (
	echo compiling change log
	cd gitrepo
	python tools/ss13_genchangelog.py html/changelog.html html/changelogs
	if %ERRORLEVEL% == 0 (
		echo pushing compiled changelog to server
		git add -u html/changelog.html
		git add -u html/changelogs
		git commit -m "Automatic Changelog Generation"
		if %ERRORLEVEL% == 0 (
			git push
		)
		REM an error here generally means there was nothing to commit.
	)
	cd ..
)

call bin\findab.bat

call bin\copyfromgit.bat



if not defined PUSHCHANGELOGTOGIT (
	echo compiling change log
	cd gamecode\%AB%
	call python tools\ss13_genchangelog.py html/changelog.html html/changelogs
	cd ..\..
)



echo building script.
call bin\build.bat
if %DM_EXIT% neq 0 (
	echo DM compile failed. Aborting.
	call ircbots.bat "DM compile failed. Aborting update." >nul 2>nul
	@del /F /Q updating.lk >nul 2>nul
	pause
	exit /b 1
)

@del updating.lk >nul 2>nul
rmdir /q gamefolder
mklink /d gamefolder gamecode\%AB% >nul
call ircbots.bat "Update job finished. Update will take place next round." >nul 2>nul
echo Done. The update will automatically take place at round restart.
timeout 60