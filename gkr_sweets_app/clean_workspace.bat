@echo off
echo Cleaning Flutter workspace...
flutter clean
rem Removing generated files
rd /s /q .dart_tool
rd /s /q build
echo Clean complete.
