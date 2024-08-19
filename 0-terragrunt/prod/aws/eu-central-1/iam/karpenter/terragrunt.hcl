terraform {
    source = "tfr:///terraform-aws-modules/eks/aws//modules/karpenter?version=20.23.0"
}

include "root" {
  path = find_in_parent_folders()
}
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

dependency "eks" {
  config_path = "../../eks"
}

inputs ={
  cluster_name                    = dependency.eks.outputs.cluster_name
  cluster_endpoint                = dependency.eks.outputs.cluster_endpoint
  irsa_oidc_provider_arn          = dependency.eks.outputs.oidc_provider_arn
  create_iam_role                 = true
  iam_role_name                   = "karpenter-controller"
  irsa_namespace_service_accounts = ["karpenter:karpenter"]
  enable_irsa                     = true
  create_instance_profile         = true
  node_iam_role_arn               = dependency.eks.outputs.eks_managed_node_groups["eks-node"].iam_role_arn
  create_node_iam_role            = false
  create_access_entry             = false
  
  tags = {
      Environment = include.env.locals.environment
      Terraform = "true"
  }
}