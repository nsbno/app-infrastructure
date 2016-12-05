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
        "${aws_security_group.appserver.id}",
        "${aws_security_group.appserver_internal_communication.id}",
        "${var.allow_bastion_access_security_group_id}",
        "${var.allow_outgoing_traffic_security_group_id}",
        "${var.icmp_security_group_id}"
    ]

    tags { Name = "${var.appserver_name} ${count.index}" }
}

