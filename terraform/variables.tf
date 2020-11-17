variable "region" {
  default = "us-west-1"
}
variable "environment" {
  default = "cse-development"
}
variable "vpc_cidr" {
  description = "VPC cidr block"
}
variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 cidr block"
}
variable "public_subnet_2_cidr" {
  description = "Public Subnet 2 cidr block"
}
variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 cidr block"
}
variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 cidr block"
}
variable "instance_type" {

}
variable "instance_ami" {
}
variable "keyname" {
}
variable "team_name" {
}
