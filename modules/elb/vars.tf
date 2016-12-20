# ELB
variable "elb_name" {}

# VPC
variable "vpc_id" {}

# Subnets
variable "public_subnet_ids" { type = "list" }

# Apps
variable "app_ids" { type = "list" }

# Security groups
variable "elb_sg" {}
