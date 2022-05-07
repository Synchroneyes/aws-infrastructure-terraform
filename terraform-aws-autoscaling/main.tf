### Provider definition

provider "aws" {
  region = "${var.aws_region}"
}

### Module Main

module "discovery" {
  source              = "github.com/Lowess/terraform-aws-discovery"
  aws_region          = var.aws_region
  vpc_name            = var.vpc_name
  ec2_ami_names       = ["amzn2-ami-hvm-2.0.20210813.1-x86_64-gp2"]
  ec2_ami_owners      = "amazon"
}

