terraform {
  backend "s3" {
    bucket = "sparta-terraform-state"
    key    = "node-example-app"
    region = "eu-west-2"
  }
}

provider "aws" {
  region  = "eu-west-2"
}

module "vpc" {
  source = "./terraform/modules/vpc"
  name="node-example-app"
  cidr_block="10.0.0.0/16"
}

data "aws_ami" "latest" {
    most_recent = true

    filter {
        name   = "name"
        values = ["example-node-app-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_subnet" "app" {
  vpc_id = "${module.vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = "false"
  tags {
    Name = "node-example-app-private"
  }
}


data "template_file" "app_init" {
   template = "${file("./terraform/scripts/app/init.sh")}"
}

resource "aws_instance" "app" {
  ami           = "${data.aws_ami.latest.id}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.app.id}"
  user_data     = "${data.template_file.app_init.rendered}"
  tags {
    Name = "node-example-app"
  }
}

resource "aws_elb" "elb" {
  name = "node-example-app-elb"
  subnets = ["${aws_subnet.app.id}",]

  listener {
    instance_port = 3000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    interval = 60
    target = "HTTP:3000/"
    timeout = 20
  }
  
  tags {
    Name = "node-example-app-elb"
  }
 }

# resource "aws_subnet" "db" {
#   vpc_id = "${module.vpc.id}"
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "eu-west-2a"
#   map_public_ip_on_launch = "false"
#   tags {
#     Name = "node-example-db-private"
#   }
# }

# resource "aws_instance" "db" {
#   ami           = "ami-5423ce33"
#   instance_type = "t2.micro"
#   subnet_id     = "${aws_subnet.db.id}"

#   tags {
#     Name = "node-example-db"
#   }
# }
