variable "region" {
  description = "the region in which to launch the architecture"
  default="eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "sparta-terraform-state"
    key    = "node-example-app"
    region = "eu-west-2"
  }
}

provider "aws" {
  region  = "eu-west-2"
  assume_role {
    role_arn     = "arn:aws:iam::135928476890:role/TerraformLondon"
    session_name = "TerraformLondon"
  }
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

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.latest.id}"
  instance_type = "t2.micro"

  tags {
    Name = "node-example-app"
  }
}