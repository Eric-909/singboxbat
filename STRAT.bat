@echo off
setlocal enabledelayedexpansion
chcp 1252 > nul

cd /d "%~dp0"

set "subFolder=sub"
set "counter=0"
set "defaultChoice=1" 

color 0A
echo.
echo Please Choose Config Profile:
echo.

for %%F in (%subFolder%\*) do (
    set /a counter+=1
    echo !counter!. %%~nxF
    set "file[!counter!]=%%~dpnxF"
)
echo.
set /p "choice=Enter Your Choice [Default:!defaultChoice!]: "
if "!choice!"=="" set "choice=!defaultChoice!"
for /f %%A in ("!choice!") do set "choice=%%A"
set "choice=!choice: =!"

if !choice! geq 1 if !choice! leq !counter! (
    set "selectedFile=!file[%choice%]!"
    echo selected file: !selectedFile!

    set "checkResult="
    call set "checkCommand=core\sing-box.exe check -c "!selectedFile!" 2>&1"
    for /f "delims=" %%i in ('!checkCommand!') do set "checkResult=%%i"
    if not "!checkResult!"=="" (
        echo "Check failed"
        echo !checkResult!
        pause
    ) else (
        echo Requesting Administrator Privileges...
        powershell -Command "& { Start-Process 'core\sing-box.exe' -ArgumentList 'run -c "!selectedFile!"' -Verb RunAs }"
        start http://127.0.0.1:9090
        exit /b
    )
    
) else (
    echo Error...
    pause
    exit /b 1
)