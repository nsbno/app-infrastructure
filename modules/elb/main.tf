resource "aws_elb" "app" {
  name = "${var.elb_name}"

  subnets                     = ["${var.public_subnet_ids}"]
  security_groups             = ["${aws_security_group.load_balancer.id}"]
  instances                   = ["${var.app_ids}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_cert_arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${var.healthcheck_target}"
    interval            = 30
  }

  tags { Name = "${var.elb_name}" }

}

