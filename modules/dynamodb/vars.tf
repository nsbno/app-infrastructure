variable "env" {
}

variable "name" {
}

variable "hash_key" {
}

variable "range_key" {
  default = null
}

variable "billing_mode" {
  default = "PROVISIONED"
}

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

variable "attributes" {
  type = list(object({
    name = string,
    type = string
  }))
}

variable "indices" {
  type = list(object({
    hash_key           = string,
    name               = string,
    projection_type    = string,
    non_key_attributes = list(string)
  }))

  default = []
}