output "instance_id" {
  description = "ID of the Minecraft EC2 instance. Reboot test script uses this value"
  value       = aws_instance.minecraft.id
}

output "instance_public_ip" {
  description = "Public IP address for Ansible and the nmap test"
  value       = aws_instance.minecraft.public_ip
}

output "security_group_id" {
  description = "ID of the Minecraft security group."
  value       = aws_security_group.minecraft.id
}


output "nmap_command" {
  description = "Nmap command used to test the Minecraft server port."
  value       = "nmap -sV -Pn -p T:25565 ${aws_instance.minecraft.public_ip}"
}

output "ansible_inventory_line" {
  description = "Inventory line used by Ansible to configure the EC2 instance."
  value       = "minecraft ansible_host=${aws_instance.minecraft.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/minecraft_iac_key"
}
