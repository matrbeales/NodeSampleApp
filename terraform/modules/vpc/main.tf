resource "aws_vpc" "app" {
  cidr_block = "${var.cidr_block}"
  
  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "app" {
  vpc_id = "${aws_vpc.app.id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.app.default_route_table_id}"

  tags {
    Name = "${var.name}-default"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app.id}"
  }

  tags {
    Name = "${var.name}-public"
  }
}

