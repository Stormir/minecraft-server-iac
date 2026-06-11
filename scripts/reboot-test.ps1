$ErrorActionPreference = "Stop"
# This scrip proves the server still works after reboot
# It uses AWS CLI instead of AWS Console, then checks the minecraft port again using nmap 

Write-Host "Starting reboot test" -ForegroundColor Cyan
$repoRoot = Split-Path $PSScriptRoot -Parent
$terraformDir = Join-Path $repoRoot "terraform"

$env:AWS_PAGER = ""

Push-Location $terraformDir
$instanceId = terraform output -raw instance_id
$publicIp = terraform output -raw instance_public_ip
Pop-Location

Write-Host "Instance ID: $instanceId" -ForegroundColor Green
Write-Host "Public IP: $publicIp" -ForegroundColor Green

Write-Host "`nTesting Minecraft before reboot" -ForegroundColor Yellow
nmap -sV -Pn -p T:25565 $publicIp

Write-Host "`nRebooting EC2 instance" -ForegroundColor Yellow
aws ec2 reboot-instances --instance-ids $instanceId

Write-Host "Waiting for instance status checks to pass" -ForegroundColor Yellow
Start-Sleep -Seconds 30
aws ec2 wait instance-status-ok --instance-ids $instanceId

Write-Host "`nExtra time for Minecraft to start up " -ForegroundColor Yellow
Start-Sleep -Seconds 45

Write-Host "`nTesting Minecraft after reboot" -ForegroundColor Yellow
nmap -sV -Pn -p T:25565 $publicIp

Write-Host "`nReboot test complete." -ForegroundColor Green

