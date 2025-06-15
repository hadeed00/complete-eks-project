module "vpc" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc?ref=v5.2.0"
  # version = "5.2.0"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs                  = ["${var.region}a", "${var.region}b"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true 

  # Enable NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
  
  # Add required tags for EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}