# Provision Highly Available Web in any Region Default VPC

This Terraform script creates a highly available web application infrastructure with zero downtime and green/blue deployment in the default VPC of any region. It includes the following resources:

- Security Group for Web Server
- Launch Configuration with Auto AMI Lookup
- Auto Scaling Group using 2 Availability Zones
- Classic Load Balancer in 2 Availability Zones

## Prerequisites

- AWS account credentials
- Terraform CLI

## Usage

1. Clone the repository.
2. Initialize the Terraform working directory and download the necessary provider plugins by running the command: `terraform init`.
3. Don't forget to provide your credentials using following commands:

		export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
		export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
		
4. Modify the `region` parameter in the `provider` block to your desired region or provide your Region using following command:

		export AWS_DEFAULT_REGION="YOUR-REGION"
		
5. Run `terraform plan` to see the changes to be made by the script.
6. If the plan looks good, apply the changes by running `terraform apply`.

## Author

Made by Vitali Aleksandrov on 22-April-2023.


