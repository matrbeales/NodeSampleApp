data "aws_region" "current" {}

resource "aws_subnet" "tier" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.cidr_block}"
  availability_zone = "${data.aws_region.current.name}${var.availability_zone}"
  map_public_ip_on_launch = "false"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_security_group" "tier"  {
  name = "${var.name}"
  description = "${var.name} access"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]   
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}"
  }
}

resource "aws_instance" "tier" {
  ami           = "${var.ami_id}"
  subnet_id     = "${aws_subnet.tier.id}"
  vpc_security_group_ids = ["${aws_security_group.tier.id}"]
  instance_type = "${var.instance_type}"
  tags {
    Name = "${var.name}"
  }
}