variable "appname" {
}

variable "env" {
}

variable "policy_name" {
  type = string
  default = "get-secret-policy"
}


variable "secret_ids" {
  type = list(string)
}

variable "role_name" {
}

