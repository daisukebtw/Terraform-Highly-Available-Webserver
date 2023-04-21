#----------------------------------------------------------
# Provision Highly Available Web in any Region Default VPC
#   - Zero DownTime
#   - Green/Blue Deployment
#
# Create: 
#    - Security Group for Web Server
#    - Launch Configuration with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
#
# Made by Vitali Aleksandrov 22-April-2023
#-----------------------------------------------------------


# Using AWS to create instances
provider "aws" {
    region     = "eu-central-1"
}


# Getting AWS AMI data to get latest AMI ID
data "aws_ami" "latest" {
    owners      = ["137112412989"]
    most_recent = true
    filter {
      name   = "name"
      values = ["al2023-ami-2023.*-x86_64"]
    }
    filter {
      name   = "description"
      values = ["Amazon Linux 2023 AMI 2023*"]
    }
  
}


# Creating AWS Security Group with HTTP and HTTPS access
resource "aws_security_group" "main_sg" {
  dynamic "ingress" {
    for_each = ["80", "443"] # Opening specified ports
    content {
      to_port     = ingress.value # Using Dynamic variables
      from_port   = ingress.value # Using Dynamic variables
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Creating AWS Lauch Configuration using latest AWS AMI ID  
resource "aws_launch_configuration" "web" {
    name_prefix     = "Webserver-Highly-Available-"
    image_id        = data.aws_ami.latest.id # Using latest AWS AMI ID
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.main_sg.id] # Attaching Security Group to Launch Configuration

    # Enabling IMDSv1
    metadata_options {
      http_put_response_hop_limit = 3
      http_endpoint               = "enabled"
      http_tokens                 = "optional"
    }

    # Attaching User Data file
    user_data = file("userdata.tpl")

    # Make AWS create new instance before destroy old one
    lifecycle {
      create_before_destroy = true
    }
}


# Getting AWS Availability Zone data
data "aws_availability_zones" "available" {}


# Getting Subnets in the specified Availability Zone
resource "aws_default_subnet" "default_az1" {
    availability_zone = data.aws_availability_zones.available.names[0]
}


# Getting Subnets in the specified Availability Zone
resource "aws_default_subnet" "default_az2" {
    availability_zone = data.aws_availability_zones.available.names[1]
}


# Creating AWS Load Balancer
resource "aws_elb" "main_elb" {
    name = "WebServer-HA-ELB"

    # Pointing out to which Availability Zones send traffic
    availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]

    security_groups = [aws_security_group.main_sg.id] # Attaching Security Group to Load Balancer

    listener {
      lb_port           = 80
      lb_protocol       = "http"
      instance_port     = 80
      instance_protocol = "http"
    }

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      target              = "HTTP:80/"
      interval            = 10
    }

    tags = {
        Name = "Webserver-Higly-Available-ELB"
    }
}


# Creating AWS Autoscaling Group and attaching Load Balancer
resource "aws_autoscaling_group" "main_asg" {
    name                 = "ASG-${aws_launch_configuration.web.name}"
    launch_configuration = aws_launch_configuration.web.name
    min_size             = 2
    max_size             = 2
    min_elb_capacity     = 2
    
    # Attaching subnets for Autoscaling group to create instances in indicated Availability Zones
    vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

    load_balancers    = [aws_elb.main_elb.name] # Attaching Load Balancer
    health_check_type = "ELB" # Using health check from Load Balancer


    # Creating Dynamic Tag
    dynamic "tag" {

        # List for Dynamic Tag
        for_each = {
            Name  = "WebServer-ASG"
            Owner = "daisuke"

        }
      content {
        key                 = tag.key # Using Dynamic variables
        value               = tag.value # Using Dynamic variables
        propagate_at_launch = true
      }
    }

    # Make AWS create new Autoscaling Group before destroy old one
    lifecycle {
      create_before_destroy = true
    }
}


# Making Output with made Load Balacer Link
output "elb_dns" {
    value = aws_elb.main_elb.dns_name
}


