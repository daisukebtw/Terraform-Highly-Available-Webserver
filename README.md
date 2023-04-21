![My Remote Image](https://i.ibb.co/PGRsmhR/aws-tf.png)


# My AWS Learning Journey

In this repository, I am documenting my journey of learning AWS and the services that I have learned so far. Currently, I am familiar with the following services:

- EC2
- S3
- VPC

I have also started learning Terraform and have already completed my first project, Highly Available Webserver, which is available in this repository.

## AWS Services

### EC2

Amazon Elastic Compute Cloud (EC2) is a web service that provides resizable compute capacity in the cloud.

### S3

Amazon Simple Storage Service (S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance.

### VPC

Amazon Virtual Private Cloud (VPC) enables you to launch Amazon Web Services (AWS) resources into a virtual network that you've defined.

## Terraform

### Highly Available Web Server with Terraform

To launch the highly available web server infrastructure, follow these steps:

1. Clone this repository to your local machine.
2. Install Terraform on your local machine, following the instructions in the [official Terraform documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3. Navigate to the `terraform` directory in your terminal.
4. Run `terraform init` to initialize the working directory and download necessary plugins.
5. Run `terraform apply` to apply the changes to the infrastructure. You will be prompted to enter the AWS access key and secret access key (Credentials).
6. Once the infrastructure is created, the output will display the load balancer's DNS name. Copy and paste the DNS name into your web browser to confirm that the web server is running.

To destroy the infrastructure, run `terraform destroy` in the `terraform` directory.

### AWS Credentials

To configure AWS credentials, you can follow these steps:

1. Go to the [AWS Management Console](https://console.aws.amazon.com/)
2. Click on your account name and select **My Security Credentials**
3. Click on **Create access key**
4. Save your access key ID and secret access key in a safe place
5. Configure the AWS CLI or SDKs with your access key ID and secret access key

For more information on configuring AWS credentials, you can refer to the [AWS Documentation](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys).




## Set AWS Credentials in Windows PowerShell:

    $env:AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
    $env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
    $env:AWS_DEFAULT_REGION="YOUR_REGION"

## Set AWS Credentials in Linux Shell:

    export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
    export AWS_DEFAULT_REGION="YOUR_REGION"
