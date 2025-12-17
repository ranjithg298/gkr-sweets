@echo off
echo Fetching Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
  echo flutter pub get failed && exit /b %errorlevel%
)
echo Running Flutter app...
flutter run
