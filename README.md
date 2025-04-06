# AWS Terraform NAT Gateway Setup

This Terraform project sets up AWS private subnet EC2 instance and aims to make it internet accessable through NAT Gateway Additionally it provides EC2 instance running Apache in a public subnet enabling direct internet access via an Internet Gateway, Both EC2 instances has security group is configured to allow HTTP (80), SSH (22), and HTTPS (443) traffic

![Image](https://github.com/user-attachments/assets/5c2f16dc-9561-4983-b5a2-656088f671f0)


## Resources Created

1. **VPC**: A Virtual Private Cloud is created using the CIDR block provided in the `variables.tf` file.
2. **Public Subnet**: A public subnet with internet access is created.
3. **Private Subnet**: A private subnet without internet access is created.
4. **Internet Gateway**: An Internet Gateway is created and attached to the VPC for internet access to the public subnet.
5. **Elastic IP**: An Elastic IP is created for the NAT Gateway.
6. **NAT Gateway**: A NAT Gateway is created in the public subnet to allow outbound internet access for resources in the private subnet.
7. **Route Tables**: 
   - Public Route Table (`pub_RT`) for the public subnet.
   - Private Route Table (`priv_RT`) for the private subnet.
8. **Security Group**: A security group for the public EC2 instances that allows HTTP, HTTPS, and SSH traffic.
9. **EC2 Instances**:
   - **Public EC2 Instance**: An EC2 instance in the public subnet with a public IP address.
   - **Private EC2 Instance**: An EC2 instance in the private subnet without a public IP address.
10. **S3 Bucket**: An S3 bucket is created to store the backend state for Terraform.

## Prerequisites

1. **Terraform**: Ensure that you have Terraform installed. You can download it from [Terraform's official site](https://www.terraform.io/downloads).
2. **AWS Account**: You need an AWS account with the necessary IAM permissions to create resources like VPC, EC2 instances, and S3 buckets.
3. **AWS CLI**: Install the AWS CLI to configure your credentials.
4. **IAM Permissions**: Ensure you have permissions to create and manage VPCs, subnets, EC2 instances, NAT Gateways, Elastic IPs, S3 buckets, etc.

## Results
In Order to verify **NAT Gateway** is working and providing internet access to the private EC2 instance follow these steps:

### 1. SSH into the Public EC2 Instance 
I used the private keypair which generated from keypairs.tf file to shh on the public after i saved it locally in this path ~/.ssh/my_terraform_key.pem

### 2. SSH into the Private EC2 Instance from the Public EC2 Instance
I used secure copy with scp command to  copy the key to Public EC2 Instance which placed in public subnet, So we can use this key later to have ssh connection on Private EC2 Instance on the private subnet in same VPC **I can't ssh directly from my local machine to Private EC2 Instance as it doesn't have public ip**

### 3.  Test Internet Connectivity from the Private EC2 Instance
 


![Image](https://github.com/user-attachments/assets/2281baa6-d0e3-44bb-a83a-384e47697491)


## How to Use

1. **Clone the repository**:
   ```bash
   git clone https://github.com/khkhkhkhader/AWS-Terraform-NAT-GW-Setup.git
   cd AWS-Terraform-NAT-GW-Setup
