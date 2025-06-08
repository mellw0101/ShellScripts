param (
  [string]$Suffix
)

if (-not $Suffix) {
  Write-Host "Usage: check_appx.ps1 <PackageSuffix>" -ForegroundColor Yellow
  exit 1
}

$pkg_name = "Microsoft.$Suffix"
$pkg = Get-AppxPackage -Name $pkg_name

if ($pkg) {
  Write-Host "Package '$($pkg.Name)' exists." -ForegroundColor Green
  exit 0
}
else {
  Write-Host "Package '$($pkg_name)' DOES NOT exist." -ForegroundColor Red
  exit 2
}
