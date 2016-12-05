/*
  Database Servers
*/

resource "aws_db_instance" "db" {
  name                   = "${var.db_name}"
  depends_on             = ["aws_db_parameter_group.default"]
  identifier             = "${var.db_identifier}"
  allocated_storage      = "${var.db_storage}"
  engine                 = "${var.db_engine}"
  engine_version         = "${var.db_engine_version}"
  instance_class         = "${var.db_instance_class}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  db_subnet_group_name   = "${var.db_subnet_group_id}"
  parameter_group_name   = "${var.db_parameter_group_name}"
  apply_immediately      = "true"
}

resource "aws_db_parameter_group" "default" {
    name   = "${var.db_parameter_group_name}"
    family = "${var.db_family}"

    parameter {
      name         = "log_bin_trust_function_creators"
      value        = "1"
      apply_method = "pending-reboot"
    }

    parameter {
      name         = "character_set_client"
      value        = "latin1"
    }

    parameter {
      name         = "character_set_server"
      value        = "latin1"
    }

    parameter {
      name         = "character_set_connection"
      value        = "latin1"
    }

    parameter {
      name         = "character_set_results"
      value        = "latin1"
    }

    parameter {
      name         = "collation_connection"
      value        = "latin1_swedish_ci"
    }

    parameter {
      name         = "collation_server"
      value        = "latin1_swedish_ci"
    }

    parameter {
      name         = "init_connect"
      value        = "SET NAMES latin1"
    }

    parameter {
      name         = "sql_mode"
      value        = "NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES"
    }

    parameter {
      name         = "time_zone"
      value        = "Europe/Amsterdam"
      apply_method = "pending-reboot"
    }
}
