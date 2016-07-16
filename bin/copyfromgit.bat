echo Removing old files
rem delete the symlinks manually to ensure their targets don't get recursively deleted
rmdir /q gamecode\%AB%\data >nul 2>nul
rmdir /q gamecode\%AB%\config >nul 2>nul

del /S /F /Q gamecode\%AB% >nul 2>nul

echo Copying files
xcopy gitrepo gamecode\%AB% /Y /X /K /R /H /I /C /V /E /Q /EXCLUDE:copyexclude.txt >nul
mkdir gamecode\%AB%\.git\logs
copy gitrepo\.git\logs\HEAD gamecode\%AB%\.git\logs\HEAD /D /V /Y >nul
copy gitrepo\config\example\* gamedata\config\example\ /D /V /Y >nul
copy gitrepo\config\names\* gamedata\config\names\ /D /V /Y >nul
copy gitrepo\config\news\* gamedata\config\news\ /D /V /Y >nul

rmdir /q gamecode\%AB%\data >nul 2>nul
rmdir /s /q gamecode\%AB%\data >nul 2>nul
mklink /d gamecode\%AB%\data ..\..\gamedata\data >nul
mklink /d gamecode\%AB%\config ..\..\gamedata\config >nul