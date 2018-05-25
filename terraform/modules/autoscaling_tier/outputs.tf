output "endpoint" {
  value = "${aws_elb.elb.dns_name}"
}

output "app_security_group_id" {
  value="${aws_security_group.app.id}"
}