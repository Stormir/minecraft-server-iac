$ErrorActionPreference = "Stop"

# This script checks the local tools before I try to build anything in AWS
# Its meant to catch missing installs early on 
Write-Host "Checking local project tools" -ForegroundColor Cyan
Write-Host "`nGit:" -ForegroundColor Yellow
git --version

Write-Host "`nAWS CLI:" -ForegroundColor Yellow
aws --version

Write-Host "`nTerraform:" -ForegroundColor Yellow
terraform version

Write-Host "`nNmap:" -ForegroundColor Yellow
nmap --version

Write-Host "`nWSL:" -ForegroundColor Yellow
wsl --version

Write-Host "`nChecking AWS identity" -ForegroundColor Yellow
$env:AWS_PAGER = ""
aws sts get-caller-identity | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "AWS CLI credentials aren't configured correctly."
}
Write-Host "AWS CLI credentials are configured." -ForegroundColor Green

Write-Host "`nChecking that Ansibles inside WSL Ubuntu..." -ForegroundColor Yellow
wsl -d Ubuntu -- bash -lc "ansible --version | head -n 1 && python3 --version"

Write-Host "`nSetup check is complete." -ForegroundColor Green