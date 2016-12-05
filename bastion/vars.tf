# Bastion
variable "bastion_name" {}
variable "bastion-ami" {
  description = "Hardened ami based on ami-ea26ce85"
  default = "ami-b1b14cde"
}

variable "key_pair_id" {}

variable "bastion_eip_allocation_id" {}

# VPC
variable "vpc_id" {}

# Subnets
variable "public_subnet_ids" { type = "list" }

# Security groups
variable "icmp_security_group_id" {}
variable "allow_outgoing_traffic_security_group_id" {}
