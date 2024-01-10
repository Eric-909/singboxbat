@echo off
setlocal enabledelayedexpansion
for /f "usebackq tokens=1" %%i in (`powershell -command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/SagerNet/sing-box/releases/latest').tag_name"`) do (
    set latest_version=%%i
)

if "%latest_version%" neq "01" (
    mkdir temp
    cd temp
    set download_url=https://github.com/SagerNet/sing-box/releases/download/%latest_version%/sing-box-%latest_version:v=-windows-amd64.zip
    "%~dp0core\wget.exe" -q -O "sing-box-%latest_version:v=-windows-amd64.zip" "%download_url%"
    unzip -o "sing-box-%latest_version:v=-windows-amd64.zip" -d .
    move "sing-box-%latest_version:v=-windows-amd64\*" "%~dp0core\"
    cd ..
    rmdir /s /q temp

)