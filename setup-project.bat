@echo off
set /p PROJECT_NAME="Project name (kebab-case): "
set /p DEST_PATH="Destination path (blank = Documents\engineering_projects): "

if "%DEST_PATH%"=="" set DEST_PATH=%USERPROFILE%\Documents\engineering_projects

powershell.exe -ExecutionPolicy Bypass -File "%~dp0scripts\setup-project.ps1" -ProjectName "%PROJECT_NAME%" -DestinationPath "%DEST_PATH%"
pause
