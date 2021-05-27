variable "appname" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "user_pool_id" {
  type = string
}

variable "role_name" {
  type    = string
  default = ""
}

variable "oauth_scopes" {
  type    = list(string)
  default = []
}

variable "store_credentials" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
