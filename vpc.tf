# refer to vpc module at this location from the registry.terraform.io
# https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/v5.7.1/examples/complete/main.tf
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# with the module the route tables will be created automatically and the subnets will be linked.
module  "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = var.VPC_NAME
    cidr = var.VpcCIDR
    azs = [var.ZONE1, var.ZONE2, var.ZONE3]
    private_subnets = [var.PrivSub1CIDR, var.PrivSub2CIDR, var.PrivSub3CIDR]
    public_subnets = [var.PubSub1CIDR, var.PubSub2CIDR, var.PubSub3CIDR]

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Terraform = "true"
        Environment = "Prod"
    }
    vpc_tags = {
        Name = var.VPC_NAME
    }
}

