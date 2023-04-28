# Creating variable with port list to Attach to Security Group
variable "allow_port_list" {
  default = ["80", "443"]
}

# Creating variable with Launch Configuratin name value
variable "lc_name" {
  default = "Main-LC"
}

# Creating variable with Load Balancer name value
variable "elb_name" {
  default = "Main-ELB"
}

# Creating variable with Instance type value
variable "instance_type" {
  description = "Enter instance type"
  default     = "t2.micro"
}


