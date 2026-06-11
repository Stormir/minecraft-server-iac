$ErrorActionPreference = "Stop"

# this scrip handles the terraform portion of the project.
# It creates the SSH key if needed, writing terraform.tfvars, and supplies the AWS resources.  


Write-Host "Starting Terraform deployment" -ForegroundColor Cyan
$repoRoot = Split-Path $PSScriptRoot -Parent
$terraformDir = Join-Path $repoRoot "terraform"
$keyPath = Join-Path $env:USERPROFILE ".ssh\minecraft_iac_key"
$publicKeyPath = "$keyPath.pub"

$env:AWS_PAGER = ""

if (!(Test-Path $publicKeyPath)) {
    Write-Host "Creating SSH key for Ansible..." -ForegroundColor Yellow
    mkdir "$env:USERPROFILE\.ssh" -Force | Out-Null
    ssh-keygen -t rsa -b 4096 -f $keyPath -N ""
}
else {
    Write-Host "SSH key already exists." -ForegroundColor Green
}

Write-Host "Checking public IP for SSH access" -ForegroundColor Cyan
$myIp = (Invoke-RestMethod https://checkip.amazonaws.com).Trim()

$tfvars = @"
aws_region      = "us-east-1"
project_name    = "stormi-minecraft-iac"
instance_type   = "t3.small"
public_key_path = "~/.ssh/minecraft_iac_key.pub"
ssh_cidr        = "$myIp/32"
"@

Set-Content -Path (Join-Path $terraformDir "terraform.tfvars") -Value $tfvars

Push-Location $terraformDir

terraform fmt
terraform init
terraform validate
terraform apply -auto-approve
terraform output

Pop-Location

Write-Host "Terraform deployment complete." -ForegroundColor Green