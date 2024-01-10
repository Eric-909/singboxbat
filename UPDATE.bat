@echo off
setlocal enabledelayedexpansion


set "scriptDir=%~dp0"
set "subFolder=%scriptDir%sub"
set "wgetPath=%scriptDir%core\wget.exe"
set "urlFile=%scriptDir%sub.txt"

set "timeoutSeconds=10"
if not exist "!subFolder!" mkdir "!subFolder!"
for /f "tokens=1,* delims==" %%a in (!urlFile!) do (
    if "%%a"=="NAME" (
        set "fileName=%%b"
    ) else if "%%a"=="URL" (
        set "url=%%b"

        if not "!url!"=="" (
            !wgetPath! -O !subFolder!\!fileName! -T !timeoutSeconds! -t 1 !url!
            
            if errorlevel 1 (
                echo "CONFIG !fileName! DOWNLOAD FAILED."
            ) else (
                echo "CONFIG !fileName! DOWNLOAD SUCCESSED!"
            )
        ) else (
            echo "CONFIG !fileName! IS EMPTY."
        )
    )
)

echo "BYE"
pause
