provider "aws" {
  region = "${var.region}"
}

module "ecs" {
  source = "modules/ecs"

  cluster              = "${var.project}_${var.environment}"
  project              = "${var.project}"
  cloudwatch_prefix    = "${var.environment}"  #See ecs_instances module when to set this and when not!
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  key_name             = "${aws_key_pair.ecs.key_name}"
  instance_type        = "${var.instance_type}"
  ecs_aws_ami          = "${var.ecs_aws_ami}"
  EC2_hc_graceperiod   = "${var.EC2_hc_graceperiod}"
}

resource "aws_key_pair" "ecs" {
  key_name   = "${var.project}_${var.environment}_ecs_key"
  public_key = "${file(var.public_key_path)}"
}

variable "region" {}
variable "vpc_cidr" {}
variable "project" {}
variable "environment" {}
variable "max_size" {}
variable "min_size" {}
variable "EC2_hc_graceperiod" {}
variable "desired_capacity" {}
variable "instance_type" {}
variable "ecs_aws_ami" {}
variable "public_key_path" {}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

#output "alb_tgt_grp" {
#  value = "${module.ecs.alb_tgt_grp}"
#}
