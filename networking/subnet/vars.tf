variable "vpc_id" {}
variable "number_of_subnets" {}
variable "zones" { type = "map" }
variable "cidr_blocks" { type = "map" }
variable "map_public_ip_on_launch" { default = "false" }
variable "name" {}
