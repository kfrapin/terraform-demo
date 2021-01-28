# Introduction à Terraform

## Installation
Download Terraform here: https://www.terraform.io/downloads.html
And put the binary into your system path

On MacOS, `brew` users can use the [HashiCorp Homebrew Tap](https://github.com/hashicorp/homebrew-tap)

## Terraform registry
Official and community providers can be found on [Terraform registry](https://registry.terraform.io/)

## AWS provider
Resources example provided in the `aws-demo` directory are based on [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

The AWS credentials are defined inside `.env` file 

You can copy `.env-example` file to `.env` file, and then replace expected values
```sh
# load variables environment
source .env
```

## AWS resources
The following AWS resources are managed in the `aws-demo/main.tf` file:
* `aws_vpc`
* `aws_subnet`
* `aws_internet_gateway`
* `aws_route_table`
* `aws_main_route_table_association`
* `aws_security_group`
* `aws_key_pair`
* `aws_instance`

The following AWS datasources are used in the `aws-demo/main.tf` file:
* `aws_ami`

## Terrafom apply
The `aws-demo/main.tf` file will try to create a whole infrastructure from scratch on AWS Paris (`eu-west-3`) with a brand new VPC and an EC2 inside that VPC able to communicate with Internet
```sh
# initialize terraform (modules installation)
terraform init
# apply configuration
terraform apply
# destroy infrastructure
terraform destroy
```