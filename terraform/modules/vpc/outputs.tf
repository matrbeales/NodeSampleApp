output "vpc_id" {
  value = "${aws_vpc.app.id}"
}

output "default_route_table_id" {
  value = "${aws_vpc.app.default_route_table_id}"
}

output "public_route_table_id" {
  value = "${aws_route_table.public.id}"
}
