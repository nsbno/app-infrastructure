variable "vpc_name" {}

variable "env" {}

variable "appname" {}

variable "instance_profile_name" {}


variable "oauth_scopes" {
  type = list(string)
  default = []
}
