output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

