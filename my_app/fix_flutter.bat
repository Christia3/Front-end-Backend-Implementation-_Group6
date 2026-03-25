@echo off
REM Fix Flutter pub get: Prepend Git bin to PATH and run commands
set PATH=C:\Program Files\Git\bin;%PATH%

REM Navigate to project dir
cd /d "%~dp0"

echo Running Flutter clean...
flutter clean

echo Running Flutter pub get...
flutter pub get

echo Running Flutter doctor...
flutter doctor

echo Done! Restart VSCode terminals if needed.
pause
