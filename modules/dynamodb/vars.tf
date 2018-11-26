variable "env" {}
variable "name" {}
variable "hash_key" {}

variable "stream_enabled" {
  default = false
}

variable "stream_view_type" {
  default = ""
}

variable "ttl_enabled" {
  default = false
}

variable "ttl_attribute_name" {
  default = ""
}

variable "read_capacity_max" {
  default = 20
}

variable "write_capacity_max" {
  default = 20
}

variable "encryption_enabled" {
  default = false
}
