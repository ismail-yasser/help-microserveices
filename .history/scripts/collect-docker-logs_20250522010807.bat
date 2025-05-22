@echo off
echo ===================================================
echo Docker Desktop Log Collector
echo ===================================================
echo.

echo This script will collect logs to help diagnose Docker Desktop issues.
echo.

:: Create logs directory
set "log_dir=%USERPROFILE%\Desktop\docker_logs_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set log_dir=%log_dir: =0%
mkdir "%log_dir%"

echo Creating log directory: %log_dir%
echo.

echo ===================================================
echo Collecting Docker Desktop logs
echo ===================================================
echo.

echo Collecting Docker Desktop logs...
if exist "%APPDATA%\Docker\log\" (
    xcopy /E /I "%APPDATA%\Docker\log\*" "%log_dir%\docker_logs"
)

echo Collecting Docker Desktop settings...
if exist "%APPDATA%\Docker\settings.json" (
    copy "%APPDATA%\Docker\settings.json" "%log_dir%\settings.json"
)

echo.
echo ===================================================
echo Collecting Windows logs
echo ===================================================
echo.

echo Collecting Windows Application logs...
wevtutil epl Application "%log_dir%\Application.evtx"

echo Collecting Windows System logs...
wevtutil epl System "%log_dir%\System.evtx"

echo.
echo ===================================================
echo Collecting system information
echo ===================================================
echo.

echo Collecting system information...
systeminfo > "%log_dir%\systeminfo.txt"

echo Collecting Windows version information...
ver > "%log_dir%\windows_version.txt"

echo Collecting installed programs...
wmic product get name,version > "%log_dir%\installed_programs.txt"

echo Collecting Docker version information...
docker version > "%log_dir%\docker_version.txt" 2>&1
docker info > "%log_dir%\docker_info.txt" 2>&1

echo Collecting Kubernetes version information...
kubectl version > "%log_dir%\kubectl_version.txt" 2>&1
kubectl get nodes > "%log_dir%\kubectl_nodes.txt" 2>&1

echo Collecting WSL information...
wsl --list --verbose > "%log_dir%\wsl_info.txt" 2>&1

echo Collecting network information...
ipconfig /all > "%log_dir%\ipconfig.txt"
netstat -ano > "%log_dir%\netstat.txt"

echo.
echo ===================================================
echo Log collection complete
echo ===================================================
echo.
echo Logs have been collected to: %log_dir%
echo.
echo Please provide these logs when seeking support for Docker Desktop issues.
echo.
echo Press any key to exit...
pause > nul
