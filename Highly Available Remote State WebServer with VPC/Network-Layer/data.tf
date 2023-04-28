# Getting all Available Zones in selected Region
data "aws_availability_zones" "available" {}

# Getting Data from Remote State
data "terraform_remote_state" "servers" {
  backend = "s3"
  config = {
    bucket = "daisuke-terraform"             # Enter your S3 Bucket name
    key    = "dev/servers/terraform.tfstate" # Getting data from terraform.tfstate file in dev/servers directory
    region = "eu-central-1"                  # Enter your Region
  }
}
