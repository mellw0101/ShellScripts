param (
  [string]$Suffix
)

if (-not $Suffix) {
  Write-Host "Usage: remove_appx.ps1 <PackageString>" -ForegroundColor Yellow
  exit 1
}

Get-AppxPackage $Suffix | Remove-AppxPackage -AllUsers
