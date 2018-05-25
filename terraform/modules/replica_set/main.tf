data "aws_region" "current" {}

resource "aws_subnet" "tier" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.cidr_block}"
  availability_zone = "${data.aws_region.current.name}${var.availability_zone}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "${var.name}"
  }
}

## Route table associations ##

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.tier.id}"
  route_table_id = "${var.route_table_id}"
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
    self            = true
  }

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   
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

data "template_file" "master_init" {
   template = "${file("${path.module}/scripts/master_init.sh")}"
   vars {
      replica_set_name="rs0"
      replica_one="${aws_instance.replica.0.private_ip}:27017"
      replica_two="${aws_instance.replica.1.private_ip}:27017"
   }
}

resource "aws_instance" "master" {
  key_name      = "DevOpsAdministrator"
  ami           = "${var.ami_id}"
  subnet_id     = "${aws_subnet.tier.id}"
  vpc_security_group_ids = ["${aws_security_group.tier.id}"]
  user_data     = "${data.template_file.master_init.rendered}"
  instance_type = "${var.instance_type}"
  
  tags {
    Name = "${var.name}-master"
  }
}

data "template_file" "replica_init" {
   template = "${file("${path.module}/scripts/replica_init.sh")}"
   vars {
      replica_set_name="rs0"
   }
}

resource "aws_instance" "replica" {
  count = "2"
  key_name      = "DevOpsAdministrator"
  ami           = "${var.ami_id}"
  subnet_id     = "${aws_subnet.tier.id}"
  user_data     = "${data.template_file.replica_init.rendered}"
  vpc_security_group_ids = ["${aws_security_group.tier.id}"]
  instance_type = "${var.instance_type}"

  tags {
    Name = "${var.name}-replica"
  }
}

data "template_file" "hostname" {
   template = "${aws_instance.master.private_ip}:27017,${aws_instance.replica.0.private_ip}:27017,${aws_instance.replica.1.private_ip}:27017/example?replicaSet=${var.replica_set_name}"
   vars {
      replica_set_name="rs0"
   }
}
