output "app_ids" {
  value = ["${aws_instance.app.*.id}"]
}

