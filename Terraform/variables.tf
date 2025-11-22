variable "aws_region" {}
variable "env" {}
variable "cidr_block" {}
variable "pub-cidr_block" {}
variable "pub_subnet_count" {}
variable "availability_zones" {
  type = list(string)

}
variable "ec2-instance-count" {}
variable "ec2_instance_type" {}
variable "ec2_volume_size" {}
variable "ec2_volume_type" {}

