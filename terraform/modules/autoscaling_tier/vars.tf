variable "name" {
  description = "The name to use for various resources in the tier"
}

variable "vpc_id" {
  description = "The ID of the VPC to launch the tier into"
}

variable "ami_id" {
  description = "The AMI to use for the instance"
}

variable "route_table_id" {
  description = "The ID of the route table to associate with the subnet"
}

variable "user_data" {
  description = "user_data to be assigned to the instance"
  default=" "
}

variable "app_cidr_block" {
  description = "cidr_block to use for the app subnet"
}

variable "elb_cidr_block" {
  description = "cidr_block to use for the elb subnet"
}

variable "health_check" {
  description = "The health check to use"
  default = "HTTP:3000/"
}

variable "instance_port" {
  description = "The port the app is running on"
  default = "3000"
}

variable "instance_protocol" {
  description = "the protocol the app is listening on"
  default = "http"
}

variable "instance_type" {
  description = "the EC2 instance type to use for the app"
  default = "t2.micro"
}

variable "lb_port" {
  description = "the port the ELB should listen on"
  default = "80"
}

variable "lb_protocol" {
  description = "the port the ELB should listen on"
  default = "http"
}