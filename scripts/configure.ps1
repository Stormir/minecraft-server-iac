$ErrorActionPreference = "Stop"

# This script runs the Ansible part of the project.
# Terraform gives the EC2 public IP, then Ansible uses the IP to configure Minecraft on the server

Write-Host "Starting Ansible configuration" -ForegroundColor Cyan
$repoRoot = Split-Path $PSScriptRoot -Parent
$terraformDir = Join-Path $repoRoot "terraform"
$inventoryPath = Join-Path $repoRoot "ansible\inventory.ini"

Push-Location $terraformDir
$publicIp = terraform output -raw instance_public_ip
Pop-Location

Write-Host "Using EC2 public IP: $publicIp" -ForegroundColor Green
$inventory = @"
[minecraft]
$publicIp ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/minecraft_iac_key ansible_ssh_common_args='-o StrictHostKeyChecking=no'
"@

Set-Content -Path $inventoryPath -Value $inventory

$wslRepoPath = "/mnt/c/Users/$env:USERNAME/Documents/minecraft-server-iac"
$wslKeyPath = "/mnt/c/Users/$env:USERNAME/.ssh/minecraft_iac_key"

wsl -d Ubuntu -- bash -lc "mkdir -p ~/.ssh && cp '$wslKeyPath' ~/.ssh/minecraft_iac_key && chmod 600 ~/.ssh/minecraft_iac_key && cd '$wslRepoPath' && ansible-playbook -i ansible/inventory.ini ansible/playbook.yml"

Write-Host "Ansible configuration completed" -ForegroundColor Green