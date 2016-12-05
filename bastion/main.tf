/*
  Bastion host
*/

resource "aws_instance" "bastion" {
  ami                         = "${var.bastion-ami}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_pair_id}"
  subnet_id                   = "${element(var.public_subnet_ids, 0)}"
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
    "${var.icmp_security_group_id}",
    "${var.allow_outgoing_traffic_security_group_id}"
  ]

  tags { Name = "${var.bastion_name}" }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = "${aws_instance.bastion.id}"
  allocation_id = "${var.bastion_eip_allocation_id}"
}

