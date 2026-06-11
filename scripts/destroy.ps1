$ErrorActionPreference = "Stop"

# This script removes the AWS resources that Terraform made
# The extra confirmation is to remind graders not to run before grading! :) 

Write-Host "This destroys the Terraform-created AWS resources" -ForegroundColor Red
Write-Host "Please don't run before grading is complete " -ForegroundColor Yellow

$confirmation = Read-Host "Type DESTROY to continue"

if ($confirmation -ne "DESTROY") {
    Write-Host "Destroy cancelled." -ForegroundColor Green
    exit 0
}

$repoRoot = Split-Path $PSScriptRoot -Parent
$terraformDir = Join-Path $repoRoot "terraform"

Push-Location $terraformDir
terraform destroy -auto-approve
Pop-Location

Write-Host "Terraform resources destroyed." -ForegroundColor Green