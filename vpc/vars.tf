variable "aws_region" { }
variable "vpc_name" { }
variable "key_name" {}
variable "public_key" {}
variable "ig_name" {}
variable "nat_eip_allocation_id" {}
variable "zones" { type = "map" }
variable "vpc_cidr" {}
variable "private_subnets_cidr_blocks" { type = "map" }
variable "public_subnets_cidr_blocks" { type = "map" }
variable "load_balancer_security_group_id" {}
variable "appserver_security_group_id" {}
