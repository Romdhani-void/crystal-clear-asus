param (
    [switch]$Confirm
)



if (-not $Confirm) {
    Write-Output "Run with -Confirm to actually clean."
    Write-Output "Example: .\cli.ps1 -Confirm"
    exit
}

Write-Output "Executing ASUS cleanup script..."
.\asus_cleanup.ps1