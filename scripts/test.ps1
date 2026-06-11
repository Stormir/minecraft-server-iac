$ErrorActionPreference = "Stop"
# This script tests the Minecraft server from my local machine

Write-Host "Testing Minecraft server with nmap..." -ForegroundColor Cyan

$repoRoot = Split-Path $PSScriptRoot -Parent
$terraformDir = Join-Path $repoRoot "terraform"

Push-Location $terraformDir
$publicIp = terraform output -raw instance_public_ip
Pop-Location

Write-Host "Running nmap against $publicIp on TCP port 25565..." -ForegroundColor Yellow

nmap -sV -Pn -p T:25565 $publicIp