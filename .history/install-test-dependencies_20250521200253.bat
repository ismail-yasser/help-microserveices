@echo off
REM Dependency installer script for health check testing

echo Installing necessary dependencies for health check testing...
echo =========================================================

REM Install axios in the project root for the test script
echo Installing axios for health check tests...
npm install axios --save

echo Done!
pause
