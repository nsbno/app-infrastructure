variable "role_name" {}
variable "description" { default = "" }
variable "policy_templates" {
  type = "list", default = []
}
variable "policy_names" {
  type = "list", default = []
}
variable "policy_descriptions" {
  type = "list", default = []
}
variable "type" {default = "basic", description = "valid types are basic, vpc or cdn"}
variable "policy_count" {}
