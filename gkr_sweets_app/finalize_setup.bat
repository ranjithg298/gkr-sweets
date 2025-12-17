@echo off
echo ========================================
echo  Finalizing Flutter Setup
echo ========================================
echo.

echo Step 1: Moving Flutter SDK to C:\flutter...
echo Source: %USERPROFILE%\Downloads\flutter_windows_3.24.5-stable\flutter

REM Move the folder
move "%USERPROFILE%\Downloads\flutter_windows_3.24.5-stable\flutter" "C:\"

echo.
echo Step 2: Adding Flutter to PATH...
setx PATH "%PATH%;C:\flutter\bin"

echo.
echo Step 3: Verifying installation...
C:\flutter\bin\flutter --version

echo.
echo Step 4: Running the App...
cd "c:\My Web Sites\gkr sweet\gkr_sweets_app"
call C:\flutter\bin\flutter pub get
call C:\flutter\bin\flutter run

pause
