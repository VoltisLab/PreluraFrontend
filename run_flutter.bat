@echo off
set PATH=%PATH%;C:\src\flutter\bin
cd /d C:\Users\toziz\PreluraFrontend
echo Checking available devices...
flutter devices
echo.
echo Running Flutter app...
flutter run
pause
