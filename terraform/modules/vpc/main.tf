resource "aws_vpc" "app" {
  cidr_block = "${var.cidr_block}"
  
  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "app" {
  vpc_id = "${aws_vpc.app.id}"
}