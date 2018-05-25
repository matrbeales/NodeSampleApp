## Subnets ##

resource "aws_subnet" "app" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.app_cidr_block}"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = "false"
  tags {
    Name = "${var.name}-private"
  }
}

resource "aws_subnet" "elb" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.elb_cidr_block}"
  availability_zone = "eu-west-2a"
  tags {
    Name = "${var.name}-elb-public"
  }
}

## Security Groups ##

resource "aws_security_group" "app"  {
  name = "${var.name}-app"
  description = "Allow all inbound traffic through port 3000 only"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "${var.instance_port}"
    to_port         = "${var.instance_port}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-app"
  }
}

resource "aws_security_group" "elb"  {
  name = "${var.name}-elb"
  description = "Allow all inbound traffic through port 80 and 443."
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "${var.lb_port}"
    to_port         = "${var.lb_port}"
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
    Name = "${var.name}-elb"
  }
}

## Route table associations ##

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.elb.id}"
  route_table_id = "${var.route_table_id}"
}


## ELB & ASG ##

resource "aws_elb" "elb" {
  name = "${var.name}-elb"
  subnets = ["${aws_subnet.elb.id}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port = "${var.lb_port}"
    lb_protocol = "${var.lb_protocol}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    interval = 60
    target = "${var.health_check}"
    timeout = 20
  }

  # instances  = ["${aws_instance.app.id}"]
  
  tags {
    Name = "${var.name}-elb"
  }
 }

 resource "aws_launch_configuration" "app" {
   name_prefix = "${var.name}-app"
   image_id = "${var.ami_id}"
   instance_type = "t2.micro"
   user_data = "${var.user_data}"
   security_groups = ["${aws_security_group.app.id}"]
   lifecycle {
     create_before_destroy = true
   }
 }

 resource "aws_autoscaling_group" "app" {
   load_balancers = ["${aws_elb.elb.id}"]
   name = "${var.name}-${aws_launch_configuration.app.name}-app"
   min_size = 1
   max_size = 2
   min_elb_capacity = 1
   desired_capacity = 1
   vpc_zone_identifier = ["${aws_subnet.app.id}"]
   launch_configuration = "${aws_launch_configuration.app.id}"
   tags {
     key = "Name"
     value = "${var.name}"
     propagate_at_launch = true
   }
   lifecycle {
     create_before_destroy = true
   }
 }