variable "db_name" {
  type = string
}

variable "backup_to_other_account" {
  type    = bool
  default = false
}

variable "db_subnet_group_name" {
  type = string
}

variable "db_identifier" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_parameter_group_name" {
  type = string
}

variable "db_username" {
  type    = string
  default = ""
}

variable "backup_retention_period" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = ""
}

variable "multi_az" {
  type = bool
}

variable "backup_window" {
  type = string
}

variable "maintenance_window" { # Timezone is UTC
  default = "Wed:00:45-Wed:01:15"
}

variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}

variable "apply_immediately" {
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "license_model" {
  type    = string
  default = ""
}

variable "kms_key_id" {
  type = string
}


variable "vpc_security_group_ids" {
  type = list(string)
}

variable "db_route53_hosted_zone_name" {
  type = string
}

variable "db_route53_hosted_zone_id" {
  type = string
}

