@echo off
rem Start up
title Background Changer

echo Checking for Administrator elevation...
openfiles > NUL 2>&1
if %errorlevel%==0 (
    echo.
	echo Elevation found!
	goto END
) else (
    echo.
	echo You are not running as Administrator.
)
pause
exit
:END
timeout /t 3
cls
cd /d C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
rem Change
echo Enter Background Location:
set /p background=
SET _convert=%background%
SET _convert2=%_convert:\=/%
SET _result=%_convert2:"=%
ECHO Path: %_result%
timeout /t 1 /nobreak >nul
echo.
echo Please Wait Changing Background
rem File
echo Windows Registry Editor Version 5.00 > "Background Change.reg"
echo. >> "Background Change.reg"
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> "Background Change.reg"
echo "Wallpaper"="%_result%" >> "Background Change.reg"
echo "DisableTaskMgr"=dword:00000000 >> "Background Change.reg"
rem Restart
Taskkill /IM explorer.exe /F >nul
"Background Change.reg"
start explorer.exe
exit