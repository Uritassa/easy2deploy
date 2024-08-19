terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.8.1"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  name = "${include.env.locals.environment}-vpc"
  cidr = "10.0.0.0/16"
  azs = ["${include.env.locals.region}a", "${include.env.locals.region}b"]
  private_subnets = ["10.0.0.0/24", "10.0.10.0/24"]
  private_subnet_tags = {
    Name = "${include.env.locals.environment}-private_subnet"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${include.env.locals.eks_cluster_name}-${include.env.locals.environment}" = "1"
    "kubernetes.io/cluster/${include.env.locals.eks_cluster_name}-${include.env.locals.environment}" = "owned"
    "karpenter.sh/discovery" = "${include.env.locals.eks_cluster_name}-${include.env.locals.environment}"
    "karpenter.sh/nodepool"  = "default"
  }
  public_subnets = ["10.0.20.0/24", "10.0.30.0/24"]
  public_subnet_tags = {
    Name = "${include.env.locals.environment}-public_subnet"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${include.env.locals.eks_cluster_name}-${include.env.locals.environment}" = "1"
    "kubernetes.io/cluster/${include.env.locals.eks_cluster_name}-${include.env.locals.environment}" = "owned"
    
  }
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true
  enable_dns_support = true
  manage_default_security_group = false
  map_public_ip_on_launch = false
    tags = {
    Terraform = "true"
    Environment = "${include.env.locals.environment}"
    Name = "${include.env.locals.environment}-vpc"
  }
}
