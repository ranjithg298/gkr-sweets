@echo off
echo ========================================
echo  Setting up Flutter from Local Download
echo ========================================
echo.

echo Step 1: Extracting Flutter SDK...
echo Source: %USERPROFILE%\Downloads\flutter_windows_3.24.5-stable.zip
echo Destination: C:\
echo.
echo This may take a few minutes...

REM Extract using PowerShell
powershell -Command "& {Expand-Archive -Path '%USERPROFILE%\Downloads\flutter_windows_3.24.5-stable.zip' -DestinationPath 'C:\' -Force}"

echo.
echo Step 2: Adding Flutter to PATH...
echo.

REM Add Flutter to PATH permanently
setx PATH "%PATH%;C:\flutter\bin"

echo.
echo Step 3: Verifying installation...
echo.

REM Check version
C:\flutter\bin\flutter --version

echo.
echo ========================================
echo  Setup Complete!
echo ========================================
echo.
echo Please close this terminal and open a new one to use 'flutter' command.
echo Then run:
echo cd "c:\My Web Sites\gkr sweet\gkr_sweets_app"
echo flutter pub get
echo flutter run
echo.
pause
