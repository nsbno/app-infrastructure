variable "users" {
  type        = list(string)
  description = "list of email addresses"
  default     = []
}

variable "rotation_start_time" {
  description = "When rotations will start"
  default     = "2020-08-01T00:00:00.00+02:00"
}
