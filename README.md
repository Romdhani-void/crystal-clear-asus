# Crystal Clear ASUS

A PowerShell script to permanently remove ASUS Armoury Crate and related background services and drivers from Windows 10/11.

---

## Problem
ASUS pre-installs Armoury Crate on most systems. Even after using the official uninstaller, several components remain:
- Services continue to run in the background
- Driver packages stay in the Windows DriverStore
- Windows Update silently reinstalls ASUS components
- Users report freezes, high CPU usage, and BSODs linked to ASUS services

---

## Symptoms
Common issues caused by leftover ASUS software:
- ArmouryCrateControlInterface.exe visible in Task Manager
- ASUS services listed in services.msc after uninstall
- CPU spikes from ASUS System Analysis or System Diagnosis
- Ghost drivers like armourycratecontrolinterface.inf in DriverStore
- On laptops: hotkeys (Fn keys) and touchpad gestures behaving inconsistently

---

## Solution
This repository provides:
- Script to stop and remove ASUS services
- Uninstall of ASUS driver packages from DriverStore
- Cleanup of registry entries and leftover files
- Registry policy to block ASUS drivers from Windows Update
- Instructions to disable automatic Armoury Crate installation in BIOS

---

## Folder Structure

```
crystal-clear-asus/
│
├── asus_cleanup.ps1       # Main PowerShell cleanup script
├── cli.ps1                # Thin wrapper to run cleanup from CLI
├── README.md              # Documentation
├── LICENSE                # MIT license
└── .gitignore             # Ignore junk files
```

---

## Usage

**Clone the repository or download the files:**

```powershell
git clone https://github.com/YOUR-USERNAME/crystal-clear-asus.git
cd crystal-clear-asus
```

**Open PowerShell as Administrator, then choose one of the two options:**

### Option 1: Run cleanup script directly
Executes the full cleanup immediately:
```powershell
.sus_cleanup.ps1
```

### Option 2: Run through CLI wrapper (recommended)
Safer option, requires confirmation flag:
```powershell
.\cli.ps1 -Confirm
```

- Without `-Confirm`, the script will print instructions and exit.  
- With `-Confirm`, it will run the full cleanup.  

**Reboot your system when finished.**

---

## Verification

After reboot, run:
```powershell
pnputil /enum-drivers | findstr /i "asus armoury"
Get-Service | Where-Object { $_.Name -match "asus|armoury" }
```

Both commands should return no results.

---

## Warning

On ASUS laptops, this will also remove:
- Fn hotkey functionality (brightness, volume, etc.)
- Touchpad gesture support

On desktops, these side effects do not apply.

---

## License

MIT License — free to use, modify, and share.