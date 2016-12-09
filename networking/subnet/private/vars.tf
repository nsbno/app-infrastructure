variable "vpc_id" {}
variable "number_of_private_subnets" {}
variable "zones" { type = "map" }
variable "private_subnets_cidr_blocks" { type = "map" }
variable "nat_id" {}
