variable "aws_region" {
  description = "egion where the Minecraft server will be created."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used for the AWS resources."
  type        = string
  default     = "stormi-minecraft-iac"
}

variable "instance_type" {
  description = "EC2 instance size for the Minecraft server."
  type        = string
  default     = "t3.small"
}

variable "public_key_path" {
  description = "Path to the local SSH public key."
  type        = string
  default     = "~/.ssh/minecraft_iac_key.pub"
}

variable "ssh_cidr" {
  description = "Current public IP address in CIDR format, used to limit SSH access."
  type        = string
}
