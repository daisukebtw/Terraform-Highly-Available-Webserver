variable "region" {
  description = "Enter region"
  default = "eu-central-1"
}


variable "allow_ports" {
  description = "Enter ports to allow"
  type = list
  default = ["80", "443"]
}

variable "lc_name" {
  description = "Enter Name for LC"
  default = "Webserver-Highly-Available"
}

variable "instance_type" {
  description = "Enter instance type"
  default = "t2.micro"
}

variable "elb_name" {
  description = "Enter ELB Name"
  default = "WebServer-Higly-Available-ELB"
}

variable "default_tags" {
    description = "Default Tags"
    type = map
    default = {
        Owner = "daisuke"
    }
}

variable "autoscaling_group_max-size" {
  description = "Enter maximum size of your Autoscaling group"
  type = number
  default = 2
}

variable "autoscaling_group_min-size" {
  description = "Enter minimum size of your Autoscaling group"
  type = number
  default = 2
}

variable "autoscaling_desired_quantity" {
  description = "Enter desired quantity of instances"
  type = number
  default = 2
}

variable "health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done."
  default = "ELB"
}

