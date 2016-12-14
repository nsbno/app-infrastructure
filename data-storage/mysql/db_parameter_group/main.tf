resource "aws_db_parameter_group" "db_parameter_group" {
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
