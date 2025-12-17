@echo off
echo ========================================
echo  Launching GKR Sweets App
echo ========================================
echo.

echo Step 1: Configuring Environment...
setx PATH "%PATH%;C:\flutter\bin"
set PATH=%PATH%;C:\flutter\bin

echo.
echo Step 2: Verifying Flutter...
flutter --version

echo.
echo Step 3: Getting Dependencies...
cd "c:\My Web Sites\gkr sweet\gkr_sweets_app"
call flutter pub get

echo.
echo Step 4: Running App...
echo Please wait for the app to launch on your device/emulator...
call flutter run

pause
