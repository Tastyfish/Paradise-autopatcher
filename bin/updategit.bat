call bin\findgit.bat
echo Updating repo
cd gitrepo
git fetch --depth 1 origin %REPO_BRANCH%
set GIT_EXIT=%ERRORLEVEL%
if %GIT_EXIT% neq 0 goto END

for /f %%i in ('git rev-list HEAD..origin/%REPO_BRANCH% --count') do set GIT_DIFF=%%i
echo Game changed by %GIT_DIFF% commits...
if %GIT_DIFF% neq 0 goto CHECKOUT
set GIT_EXIT=UNCHANGED
git gc
goto END

:CHECKOUT
git checkout %REPO_BRANCH%
set GIT_EXIT=%ERRORLEVEL%
if %GIT_EXIT% neq 0 goto END
git reset origin/%REPO_BRANCH% --hard
set GIT_EXIT=%ERRORLEVEL%
if %GIT_EXIT% neq 0 goto END
git pull --force
set GIT_EXIT=%ERRORLEVEL%

:END
cd ..