region = "us-west-2"

vpc_cidr = "10.0.0.0/16"

project = "flask_docker_lab"

environment = "dev"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

availability_zones = ["us-west-2a", "us-west-2b"]

max_size = 2

min_size = 2

desired_capacity = 2

EC2_hc_graceperiod = 60

instance_type = "t2.micro"

ecs_aws_ami = "ami-1d668865"

public_key_path = "~/.ssh/id_rsa.pub"
