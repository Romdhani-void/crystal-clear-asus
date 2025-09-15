<#
.SYNOPSIS
    Full removal of ASUS Armoury Crate and related services/drivers.

.DESCRIPTION
    Stops ASUS services, deletes them, removes drivers from DriverStore,
    cleans registry leftovers, and blocks reinstallation via Windows Update.
#>

Write-Output "=== Crystal Clear ASUS: Starting cleanup ==="

# List of ASUS services to remove
$asusServices = @(
    "Armoury Crate Control Interface",
    "ASUS App Service",
    "ASUS Optimization",
    "ASUS Software Manager",
    "ASUS Switch",
    "ASUS System Analysis",
    "ASUS System Diagnosis",
    "AsusPTPService"
)

foreach ($svc in $asusServices) {
    sc.exe stop "$svc" 2>$null
    sc.exe delete "$svc" 2>$null
}

Write-Output "Services cleaned."

# Drivers to remove
$asusDrivers = @(
    "armourycratecontrolinterface.inf",
    "asussci2.inf",
    "asusradiocontrol.inf",
    "asusptpfilter.inf",
    "asusmcufirmwareupdate.inf"
)

foreach ($drv in $asusDrivers) {
    $oem = (pnputil /enum-drivers | Select-String -Pattern $drv -Context 0,4 | ForEach-Object {
        ($_ -match "Published Name:\s+(\S+)") ; $matches[1]
    }) | Where-Object { $_ }
    if ($oem) {
        Write-Output "Removing $drv ($oem)"
        pnputil /delete-driver $oem /uninstall /force 2>$null
    }
}

Write-Output "Drivers cleaned."

# Clean leftover folders
$paths = Get-ChildItem "C:\Windows\System32\DriverStore\FileRepository" -Directory | Where-Object {
    $_.Name -match "asus|armoury"
}
foreach ($p in $paths) {
    takeown /f $p.FullName /r /d y | Out-Null
    icacls $p.FullName /grant administrators:F /t | Out-Null
    Remove-Item -Recurse -Force -Path $p.FullName
}

Write-Output "DriverStore leftovers removed."

# Registry cleanup
$regPaths = @(
  "HKLM:\SYSTEM\CurrentControlSet\Services\ArmouryCrateControlInterface",
  "HKLM:\SYSTEM\CurrentControlSet\Services\ASUS*"
)

foreach ($r in $regPaths) {
    if (Test-Path $r) {
        Remove-Item -Recurse -Force $r
    }
}

Write-Output "Registry entries cleaned."

# Block driver reinstalls
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f | Out-Null

Write-Output "Windows Update driver reinstalls blocked."

Write-Output "=== Crystal Clear ASUS: Cleanup complete. Reboot required. ==="
