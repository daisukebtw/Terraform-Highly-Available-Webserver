# Getting Data from Remote State
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "daisuke-terraform"             # Enter your S3 Bucket name
    key    = "dev/network/terraform.tfstate" # Getting data from terraform.tfstate file in dev/network directory
    region = "eu-central-1"                  # Enter your Region
  }
}

# Getting LATEST AMI ID
data "aws_ami" "latest" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al*-ami-*.*-x86_64"]
  }
  filter {
    name   = "description"
    values = ["Amazon Linux * AMI *.*"]
  }
}

# Getting all Available Zones in selected Region
data "aws_availability_zones" "available" {}


