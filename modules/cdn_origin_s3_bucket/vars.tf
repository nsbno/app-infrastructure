variable "bucket_name" {}
variable "origin_access_id_arn" {}
variable "allowed_methods" { type = "list", default=[] }
variable "allowed_origins" { type = "list", default=[] }
