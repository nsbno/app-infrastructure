variable "db_name" {}
variable "db_name_tag" { default = "" }
variable "db_subnet_group_id" {}
variable "db_identifier" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_username" {}
variable "db_password" {}
variable "db_parameter_group_name" {}
variable "vpc_name" {}
variable "db_sg_name" {}
variable "backup_retention_period" {}
variable "availability_zone" { default = "eu-central-1a" }
variable "multi_az" {}
variable "backup_window" {}
variable "maintenance_window" { default =  "Wed:03:55-Wed:04:25" }
variable "allocated_storage" {}
variable "storage_type" {}
variable "apply_immediately" {}
variable "skip_final_snapshot" { default = "false" }
variable "license_model" { default = "" }
