variable "role_name" {}
variable "description" { default = "" }
variable "policy_templates" {
  type = "list"
}
variable "policy_names" {
  type = "list"
}
variable "policy_descriptions" {
  type = "list"
}
variable "type" {default = "basic", description = "valid types are basic, vpc or cdn"}
