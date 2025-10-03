param (
    [switch]$Confirm
)

if (-not $Confirm) {
    Write-Output "Run with -Confirm to actually clean."
    Write-Output "Example: .\cli.ps1 -Confirm"
    exit
}


