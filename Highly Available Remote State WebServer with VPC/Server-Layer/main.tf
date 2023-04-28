provider "aws" {
  region = "eu-central-1"
}


# Copying terraform.tfstate file to S3 bucket to change edit project from Remote State
terraform {
  backend "s3" {
    bucket = "daisuke-terraform"             # Enter your S3 Bucket name
    key    = "dev/servers/terraform.tfstate" # Copying to dev/servers directory
    region = "eu-central-1"                  # Enter your Region
  }
}

# Creating Launch Configuration using LATEST AMI ID
resource "aws_launch_configuration" "main" {
  name_prefix     = var.lc_name
  image_id        = data.aws_ami.latest.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.for_webserver.id]

  user_data = file("userdata.tpl")

  metadata_options {
    http_put_response_hop_limit = 3
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
  }


  lifecycle {
    create_before_destroy = true
  }
}


# Creating Autoscaling Group and Attaching ELB
resource "aws_autoscaling_group" "main" {
  name                 = "ASG-${aws_launch_configuration.main.name}"
  max_size             = 2
  min_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = [data.terraform_remote_state.network.outputs.public_subnets_ids[0], data.terraform_remote_state.network.outputs.public_subnets_ids[1]]
  load_balancers       = [aws_elb.main.name]

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {

    # List for Dynamic Tag
    for_each = {
      Name  = "WebServer-ASG"
      Owner = "daisuke"

    }
    content {
      key                 = tag.key   # Using Dynamic variables
      value               = tag.value # Using Dynamic variables
      propagate_at_launch = true
    }
  }
}

# Creating ELB and Attaching Subnets from Remote State
resource "aws_elb" "main" {
  name            = var.elb_name
  security_groups = [aws_security_group.for_webserver.id]

  # Attaching Subnets from Remote State
  subnets = [data.terraform_remote_state.network.outputs.public_subnets_ids[0], data.terraform_remote_state.network.outputs.public_subnets_ids[1]]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  depends_on = [aws_security_group.for_webserver]

  tags = {
    Name = "Main ELB"
  }
}


# Creating Security Group with allowed ports in variable
resource "aws_security_group" "for_webserver" {
  name   = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id # Getting VPC ID from Remote State
  dynamic "ingress" {
    for_each = var.allow_port_list # Getting ports from variable
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.cidr_block] # Getting CIDR BLOCKS from Remote State
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name  = "Webserver-SG"
    Owner = "daisuke"
  }
}


