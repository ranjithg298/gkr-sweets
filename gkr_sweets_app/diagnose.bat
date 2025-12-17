@echo off
echo Running Diagnosis... > diagnosis.log
echo. >> diagnosis.log

echo --- Flutter Version --- >> diagnosis.log
call C:\flutter\bin\flutter --version >> diagnosis.log 2>&1
echo. >> diagnosis.log

echo --- Flutter Doctor --- >> diagnosis.log
call C:\flutter\bin\flutter doctor >> diagnosis.log 2>&1
echo. >> diagnosis.log

echo --- Flutter Devices --- >> diagnosis.log
call C:\flutter\bin\flutter devices >> diagnosis.log 2>&1
echo. >> diagnosis.log

echo Diagnosis Complete.
