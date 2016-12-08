resource "aws_db_subnet_group" "db" {
  name        = "${var.db_subnet_group_name}"
  description = "DB subnet group"
  subnet_ids  = ["${var.private_subnet_ids}"]
}
