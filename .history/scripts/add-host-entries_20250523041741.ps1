# This script must be run as Administrator
# Right-click on PowerShell and select "Run as Administrator" before running this script

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires administrator privileges. Please run PowerShell as Administrator." -ForegroundColor Red
    exit 1
}

# Host entries to add
$hostEntries = @(
    "127.0.0.1 frontend.local",
    "127.0.0.1 user-service.local",
    "127.0.0.1 help-service.local"
)

# Path to hosts file
$hostsFile = "$env:windir\System32\drivers\etc\hosts"

# Check if entries already exist
$currentContent = Get-Content -Path $hostsFile

foreach ($entry in $hostEntries) {
    if ($currentContent -match [regex]::Escape($entry)) {
        Write-Host "Entry already exists: $entry" -ForegroundColor Yellow
    } else {
        # Add the entry to the hosts file
        Add-Content -Path $hostsFile -Value $entry
        Write-Host "Added entry: $entry" -ForegroundColor Green
    }
}

Write-Host "Host file entries have been updated successfully!" -ForegroundColor Cyan
