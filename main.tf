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

data "template_file" "app_init" {
   template = "${file("./terraform/scripts/app/init.sh")}"
   vars {
      db_endpoint="${module.db_tier.endpoint}"
   }
}

module "vpc" {
  source = "./terraform/modules/vpc"
  name="node-example-app"
  cidr_block="10.0.0.0/16"
}

module "app_tier" {
  name   = "node-example-app"
  source = "./terraform/modules/autoscaling_tier"
  vpc_id = "${module.vpc.vpc_id}"
  ami_id = "${data.aws_ami.latest.id}"
  route_table_id = "${module.vpc.public_route_table_id}"
  user_data = "${data.template_file.app_init.rendered}"
  app_cidr_block = "10.0.0.0/24"
  elb_cidr_block = "10.0.1.0/24"
}

module "db_tier" {
  name   = "node-example-db"
  source = "./terraform/modules/replica_set"
  vpc_id = "${module.vpc.vpc_id}"
  ami_id = "ami-5423ce33"
  route_table_id = "${module.vpc.public_route_table_id}"
  cidr_block = "10.0.2.0/24"
  security_groups = "${module.app_tier.app_security_group_id}"
  port = "27017"
}


