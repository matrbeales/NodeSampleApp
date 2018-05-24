variable "name" {

}

variable "ami_id" {
  
}

variable "vpc_id" {
  
}

variable "cidr_block" {
  
}

variable "port" {
  default = "80"
}

variable "security_groups" {
  
}

variable "availability_zone" {
  default = "a"
}

variable "instance_type" {
  default="t2.micro"
}