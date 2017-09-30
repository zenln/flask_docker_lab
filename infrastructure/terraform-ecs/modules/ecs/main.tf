module "network" {
  source               = "../network"
  cluster             = "${var.cluster}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  depends_id           = ""
}

module "ecs_instances" {
  source = "../ecs_instances"

  cluster                 = "${var.cluster}"
  private_subnet_ids      = "${module.network.private_subnet_ids}"
  aws_ami                 = "${var.ecs_aws_ami}"
  instance_type           = "${var.instance_type}"
  max_size                = "${var.max_size}"
  min_size                = "${var.min_size}"
  desired_capacity        = "${var.desired_capacity}"
  vpc_id                  = "${module.network.vpc_id}"
  iam_instance_profile_id = "${aws_iam_instance_profile.ecs.id}"
  key_name                = "${var.key_name}"
  load_balancers          = "${var.load_balancers}"
  depends_id              = "${module.network.depends_id}"
  custom_userdata         = "${var.custom_userdata}"
  cloudwatch_prefix       = "${var.cloudwatch_prefix}"
  EC2_hc_graceperiod      = "${var.EC2_hc_graceperiod}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster}_ecs_cluster"
}

resourc "aws_ecr_repository" "repository" {
  name = "${var.project}"
}
