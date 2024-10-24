@echo off
setlocal

:: Define the Desktop path
set DESKTOP_PATH=%USERPROFILE%\Desktop
set DSKTOP_BSH_PTH=c:\users\%USERNAME%\Desktop\practical-exam\__pycache__
echo %DSKTOP_BSH_PTH%

:: Check if the Desktop directory exists
if exist "%DESKTOP_PATH%" (
    mkdir "%DESKTOP_PATH%\practical-exam"
    cd /d "%DESKTOP_PATH%\practical-exam" || (echo Failed to navigate to Desktop & exit /b 1)
) else (
    echo Desktop directory not found.
    exit /b 1
)

:: Download the first zip file using PowerShell
powershell -Command "Invoke-WebRequest -Uri https://github.com/SauceBxss/ann/archive/refs/heads/master.zip -OutFile __pycache___.zip"
:: timeout /t 1

:: Download the second zip file using PowerShell
powershell -Command "Invoke-WebRequest -Uri https://github.com/SauceBxss/ann/archive/refs/heads/ehc.zip -OutFile ehc.zip"
:: timeout /t 1

:: Check if PowerShell's Expand-Archive is available
where powershell >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo PowerShell is required for unzipping files. Please make sure PowerShell is installed.
    pause
    exit /b 1
)

:: Unzip the files using PowerShell's Expand-Archive
mkdir __pycache__
powershell -Command "Expand-Archive -Path __pycache___.zip -DestinationPath __pycache__ -Force"
powershell -Command "Expand-Archive -Path ehc.zip -DestinationPath __pycache__ -Force"

:: Clean up
del __pycache___.zip ehc.zip

:: Navigate to __pycache__ directory
cd __pycache__ || (echo Failed to navigate to __pycache__ & exit /b 1)
echo.

:: List contents of __pycache__
dir
echo.

:: Move directories
move /Y ann-ehc\EHCS-master . || (echo Failed to move EHCS-master & exit /b 1)
move /Y ann-master\ann . || (echo Failed to move ann & exit /b 1)

:: List contents after move
echo.
dir
echo Checking if empty directories are present...
dir

:: Delete empty directories
for /d %%d in (ann-ehc ann-master) do @if exist "%%d" rmdir "%%d"

move /Y EHCS-master ehc
:: timeout /t 5

cls

echo Process completed successfully.
exit /b 0
