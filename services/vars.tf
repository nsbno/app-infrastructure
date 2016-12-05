# Appservers
variable "appserver_name" {}
variable "app_count" {}
variable "app_ami" {
  description = "Amazon Linux AMI t2.small (Variable ECUs, 1 vCPUs, 2.5 GHz, Intel Xeon Family, 2 GiB memory, EBS only) with logstash nginx and Java 1.8.0_111"
  default = "ami-d54e89ba" # based on ami-f9619996
}

variable "key_pair_id" {}

# VPC
variable "vpc_id" {}

# Subnets
variable "public_subnet_ids" { type = "list" }
variable "private_subnet_ids" { type = "list" }

# Security groups
variable "allow_outgoing_traffic_security_group_id" {}
variable "allow_bastion_access_security_group_id" {}
variable "icmp_security_group_id" {}

variable "appserver_security_group" {}
variable "load_balancer_security_group_id" {}
variable "db_security_group_id" {}
