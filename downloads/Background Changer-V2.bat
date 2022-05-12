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
cd /d D:\Users\%USERNAME%\Start Menu\Programs\Startup
rem Change
echo Enter Background Location:
set /p background=
SET _convert=%background%
SET _convert2=%_convert:\=/%
SET _result=%_convert2:"=%
echo.
ECHO Path: %_result%
timeout /t 1 /nobreak >nul
cls
echo Select Picture Position
echo 0 - Center
echo 1 - Tile
echo 2 - Stretch
echo 3 - Fit
echo 4 - Fill
echo.
set /p position=Select Postition: 
echo.
ECHO Position: %position%
timeout /t 1 /nobreak >nul
cls
echo Please Wait. Changing Background...
echo Creating File
rem File
echo Windows Registry Editor Version 5.00 > "Background Change.reg"
echo. >> "Background Change.reg"
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> "Background Change.reg"
echo "Wallpaper"="%_result%" >> "Background Change.reg"
echo "WallpaperStyle"="%position%" >> "Background Change.reg"
echo "DisableTaskMgr"=dword:00000000 >> "Background Change.reg"
rem Restart
echo Restarting Windows Explorer (explorer.exe)
Taskkill /IM explorer.exe /F >nul
"Background Change.reg"
start explorer.exe
echo Done.
echo.
echo Exiting...
exit