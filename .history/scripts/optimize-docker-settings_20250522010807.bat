@echo off
echo ===================================================
echo Docker Desktop Settings Optimizer for Kubernetes
echo ===================================================
echo.

echo This script will optimize Docker Desktop settings for Kubernetes.
echo.

set "settings_file=%APPDATA%\Docker\settings.json"
set "backup_file=%APPDATA%\Docker\settings.json.optimizer_bak"

:: Check if settings file exists
if not exist "%settings_file%" (
    echo ERROR: Docker Desktop settings file not found.
    echo Make sure Docker Desktop is installed.
    goto end
)

:: Create backup
echo Creating backup of current settings...
copy "%settings_file%" "%backup_file%"
if %errorlevel% neq 0 (
    echo ERROR: Failed to create backup of settings file.
    goto end
)

echo Settings backup created: %backup_file%
echo.

echo Analyzing current Docker Desktop settings...
echo.

:: Create a temporary file with PowerShell script
set "ps_script=%TEMP%\docker_settings_optimizer.ps1"
echo $settingsPath = '%settings_file%' > "%ps_script%"
echo $settings = Get-Content -Path $settingsPath -Raw ^| ConvertFrom-Json >> "%ps_script%"
echo. >> "%ps_script%"

echo # Display current settings >> "%ps_script%"
echo Write-Host "Current settings:" >> "%ps_script%"
echo if ($settings.kubernetesEnabled -ne $null) { Write-Host "- Kubernetes enabled: $($settings.kubernetesEnabled)" } else { Write-Host "- Kubernetes enabled: Not set" } >> "%ps_script%"
echo if ($settings.cpus -ne $null) { Write-Host "- CPUs: $($settings.cpus)" } else { Write-Host "- CPUs: Not set" } >> "%ps_script%"
echo if ($settings.memoryMiB -ne $null) { Write-Host "- Memory (MiB): $($settings.memoryMiB)" } else { Write-Host "- Memory: Not set" } >> "%ps_script%"
echo if ($settings.swapMiB -ne $null) { Write-Host "- Swap (MiB): $($settings.swapMiB)" } else { Write-Host "- Swap: Not set" } >> "%ps_script%"
echo if ($settings.wslEngineEnabled -ne $null) { Write-Host "- WSL2 backend: $($settings.wslEngineEnabled)" } else { Write-Host "- WSL2 backend: Not set" } >> "%ps_script%"
echo. >> "%ps_script%"

echo # Optimize settings >> "%ps_script%"
echo Write-Host "`nApplying optimized settings for Kubernetes..." >> "%ps_script%"
echo. >> "%ps_script%"

echo # Enable Kubernetes >> "%ps_script%"
echo $settings.kubernetesEnabled = $true >> "%ps_script%"
echo Write-Host "- Enabled Kubernetes" >> "%ps_script%"
echo. >> "%ps_script%"

echo # Check system resources and set appropriate values >> "%ps_script%"
echo $systemInfo = Get-CimInstance -ClassName Win32_ComputerSystem >> "%ps_script%"
echo $totalMemoryGB = [math]::Round($systemInfo.TotalPhysicalMemory / 1GB) >> "%ps_script%"
echo $processorCount = (Get-CimInstance -ClassName Win32_Processor ^| Measure-Object -Property NumberOfCores -Sum).Sum >> "%ps_script%"
echo. >> "%ps_script%"

echo # Set CPUs (at least 2, max 75%% of system cores) >> "%ps_script%"
echo $recommendedCPUs = [math]::Max(2, [math]::Min($processorCount - 1, [math]::Floor($processorCount * 0.75))) >> "%ps_script%"
echo $settings.cpus = $recommendedCPUs >> "%ps_script%"
echo Write-Host "- Set CPUs to $recommendedCPUs (detected $processorCount cores)" >> "%ps_script%"
echo. >> "%ps_script%"

echo # Set memory (at least 4GB, max 75%% of system RAM) >> "%ps_script%"
echo $recommendedMemoryGB = [math]::Max(4, [math]::Min($totalMemoryGB - 2, [math]::Floor($totalMemoryGB * 0.75))) >> "%ps_script%"
echo $settings.memoryMiB = $recommendedMemoryGB * 1024 >> "%ps_script%"
echo Write-Host "- Set memory to $recommendedMemoryGB GB (detected $totalMemoryGB GB system RAM)" >> "%ps_script%"
echo. >> "%ps_script%"

echo # Set swap (at least 1GB) >> "%ps_script%"
echo $recommendedSwapGB = [math]::Max(1, [math]::Floor($recommendedMemoryGB / 4)) >> "%ps_script%"
echo $settings.swapMiB = $recommendedSwapGB * 1024 >> "%ps_script%"
echo Write-Host "- Set swap to $recommendedSwapGB GB" >> "%ps_script%"
echo. >> "%ps_script%"

echo # Enable WSL 2 backend if available >> "%ps_script%"
echo $wslEnabled = (wsl --status 2^>$null) -ne $null >> "%ps_script%"
echo if ($wslEnabled) { >> "%ps_script%"
echo     $settings.wslEngineEnabled = $true >> "%ps_script%"
echo     Write-Host "- Enabled WSL 2 backend" >> "%ps_script%"
echo } >> "%ps_script%"
echo. >> "%ps_script%"

echo # Save the updated settings >> "%ps_script%"
echo $settings ^| ConvertTo-Json -Depth 10 ^| Set-Content -Path $settingsPath >> "%ps_script%"
echo Write-Host "`nSettings updated successfully. Please restart Docker Desktop to apply changes." >> "%ps_script%"

:: Run the PowerShell script
echo Running optimizer...
powershell -ExecutionPolicy Bypass -File "%ps_script%"

:: Clean up
del "%ps_script%"

echo.
echo ===================================================
echo Docker Desktop Settings Optimization Complete
echo ===================================================
echo.
echo Please restart Docker Desktop to apply the changes.
echo.
echo If you experience any issues, you can restore your original settings
echo by copying %backup_file% back to %settings_file%
echo.
echo Press any key to exit...

:end
pause > nul
