# Creating variable with "cidr_block" value
variable "cidr_block" {
  default = "10.0.0.0/16"
}

# Creating variable with "env" value
variable "env" {
  default = "dev"
}

# Creating variable with CIDR BLOCKS for Subnets
variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

