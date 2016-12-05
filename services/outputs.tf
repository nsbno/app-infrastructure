output "app_ids" {
  value = ["${aws_instance.app.*.id}"]
}

output "appserver_security_group_id" {
  value = "${aws_security_group.appserver.id}"
}