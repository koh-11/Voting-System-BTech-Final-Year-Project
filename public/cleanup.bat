@echo off
color 0A
echo Running Advanced Disk Cleanup...
echo ---------------------------------

:: Run as admin check
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script needs to run as administrator.
    pause
    exit /b
)

:: Clean Windows Temp
echo Cleaning Windows Temp...
del /s /f /q "%windir%\Temp\*.*"
for /d %%p in ("%windir%\Temp\*.*") do rmdir "%%p" /s /q

:: Clean User Temp
echo Cleaning User Temp...
del /s /f /q "%temp%\*.*"
for /d %%p in ("%temp%\*.*") do rmdir "%%p" /s /q

:: Clear Microsoft Store cache
echo Cleaning Store Delivery Optimization cache...
del /s /f /q "%SystemDrive%\ProgramData\Microsoft\Network\Downloader\*.*"

:: Clean Recycle Bin
echo Emptying Recycle Bin...
PowerShell.exe -NoProfile -Command "Clear-RecycleBin -Force"

:: Delete browser cache - Chrome
echo Deleting Google Chrome cache...
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*.*" >nul 2>&1

:: Delete browser cache - Microsoft Edge
echo Deleting Microsoft Edge cache...
del /q /f /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
del /q /f /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*.*" >nul 2>&1

:: Clear Windows Update leftovers
echo Cleaning Windows Update leftovers...
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*"

:: Clear Prefetch
echo Cleaning Prefetch files...
del /f /s /q "C:\Windows\Prefetch\*.*"

:: Clear Event Logs (optional)
echo Clearing Event Logs...
for /F "tokens=*" %%1 in ('wevtutil.exe el') DO wevtutil.exe cl "%%1"

:: Remove old system restore points, keep most recent one
echo Removing old restore points...
vssadmin delete shadows /for=C: /oldest /quiet

:: Find and delete .log and .tmp files larger than 20MB
echo Searching for .log and .tmp files > 20MB to delete...
PowerShell -Command "Get-ChildItem -Path C:\ -Include *.log,*.tmp -Recurse -ErrorAction SilentlyContinue | Where-Object {($_.Length -gt 20MB)} | Remove-Item -Force -ErrorAction SilentlyContinue"

:: Done
echo.
echo Advanced Cleanup Complete!
pause
