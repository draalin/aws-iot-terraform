variable "key_name" {
  default = "devops"
}
variable "id_rsa_pub" {
  default = "~/.ssh/id_rsa.pub"
}
variable "id_rsa" {
  default = "~/.ssh/id_rsa"
}
variable "project_name" {
  default = "iot"
}
variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type" {
  default = "t2.medium"
}
variable "instance_ami" {
  default = "ami-0758470213bdd23b1"
}
