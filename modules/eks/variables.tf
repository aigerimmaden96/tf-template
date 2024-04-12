variable "api_private_access" {}
variable "api_public_access" {}
variable "asg_desired" {}
variable "asg_max" {}
variable "asg_min" {}
variable "autoscaling" { default=true }
variable "environment" {}
variable "instance_type" {}
variable "manage_aws_auth" {
  default=true
}
variable "private_subnets" {
  type=set(string)
}
variable "private_api_access_cidrs" {}
variable "public_subnets" {
  type=set(string)
}
variable "region" {}
variable "eks_version" {}
variable "vpc_id" {}
variable "worker_ami_name_filter" { default="" }
