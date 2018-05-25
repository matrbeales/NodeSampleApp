variable "name" {

}

variable "ami_id" {
  
}

variable "vpc_id" {
  
}

variable "cidr_block" {
  
}

variable "route_table_id" {
  
}

variable "port" {
  default = "80"
}

variable "security_groups" {
  default="27017"
}

variable "availability_zone" {
  default = "a"
}

variable "instance_type" {
  default="t2.micro"
}

variable "replica_set_name" {
  default="rs0"
}