@echo off
echo ========================================
echo  GKR Sweets Flutter App Setup
echo ========================================
echo.

echo Step 1: Downloading Flutter SDK...
echo Please wait, this may take a few minutes...
echo.

REM Download Flutter SDK
powershell -Command "& {Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip' -OutFile '%USERPROFILE%\Downloads\flutter_windows.zip'}"

echo.
echo Step 2: Extracting Flutter SDK to C:\flutter...
echo.

REM Extract to C:\flutter
powershell -Command "& {Expand-Archive -Path '%USERPROFILE%\Downloads\flutter_windows.zip' -DestinationPath 'C:\' -Force}"

echo.
echo Step 3: Adding Flutter to PATH...
echo.

REM Add Flutter to PATH permanently
setx PATH "%PATH%;C:\flutter\bin"

echo.
echo Step 4: Verifying Flutter installation...
echo.

REM Refresh environment and check
C:\flutter\bin\flutter doctor

echo.
echo ========================================
echo  Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Close and reopen your terminal
echo 2. Run: flutter doctor
echo 3. Run: cd "c:\My Web Sites\gkr sweet\gkr_sweets_app"
echo 4. Run: flutter pub get
echo 5. Run: flutter run
echo.
pause
