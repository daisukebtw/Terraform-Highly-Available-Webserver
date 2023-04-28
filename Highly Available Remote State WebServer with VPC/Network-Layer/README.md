# Provision Remote State Highly Available Web in any Region with own VPC

This Terraform script creates a highly available web infrastructure using AWS resources in any region of your choice. The infrastructure includes a Virtual Private Cloud (VPC) with custom CIDR blocks, public subnets, an internet gateway, a route table with an attached internet gateway, and route table associations with subnets. The script also sets up Terraform backend to connect S3 bucket to save the project remotely and use remote state.

## Prerequisites

To use this script, you must have:

- An AWS account
- Terraform installed
- AWS CLI installed and configured with valid credentials.


## Usage

To use this script, follow the steps below:

1. Clone the repository and navigate to the directory containing the main.tf file.

2. Update the backend block in the terraform block with your S3 bucket name, key, and region.

3. Update the region variable in the provider block with the region where you want to deploy the infrastructure.

4. Update the cidr_block and public_subnet_cidrs variables in the variables.tf file with your desired CIDR blocks.

5. Run terraform init to initialize the backend.

6. Run terraform plan to preview the resources that will be created.

7. Run terraform apply to create the resources.

## Resources created

This script creates the following AWS resources:

- VPC
- Internet Gateway
- Public Subnets
- Route Table
- Route Table Associations


## Author

This script was created by Vitali Aleksandrov on April 28, 2023.
