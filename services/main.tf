/*
  App Servers
*/

resource "aws_instance" "app" {
    count                       = "${var.app_count}"
    ami                         = "${var.app_ami}"
    instance_type               = "t2.small"
    key_name                    = "${var.key_pair_id}"
    subnet_id                   = "${element(var.private_subnet_ids, count.index)}"
    associate_public_ip_address = false
    source_dest_check           = false
    vpc_security_group_ids = [
        "${var.app_security_group_id}",
        "${var.bastion_security_group_id}",
        "${var.icmp_security_group_id}"
    ]

    tags { Name = "${var.appserver_name} ${count.index}" }
}

