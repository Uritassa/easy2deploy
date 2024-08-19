terraform {
  source = "tfr:///terraform-aws-modules/eks/aws?version=20.8.5"
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
  cluster_name = "${include.env.locals.eks_cluster_name}-${include.env.locals.environment}"
  cluster_version = "${include.env.locals.cluster_version}"
  cluster_endpoint_public_access  = true
  subnet_ids  = dependency.vpc.outputs.private_subnets
  enable_irsa = true
  vpc_id = dependency.vpc.outputs.vpc_id
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
  create_cloudwatch_log_group = false
  prefix_separator = "-"
  create_kms_key = true
  attach_cluster_encryption_policy = true
  kms_key_administrators = "${include.env.locals.kms_admins}"
  node_security_group_tags = {
    "karpenter.sh/discovery" = "${include.env.locals.eks_cluster_name}-${include.env.locals.environment}"
    Environment = "${include.env.locals.environment}"
  }
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Allow all traffic within the security group"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
  eks_managed_node_group_defaults = {
    disk_size = 8
    ami_type  = "AL2023_x86_64_STANDARD"
  }
  eks_managed_node_groups = {
    eks-node = {
      use_custom_launch_template = true
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
      desired_size = 1
      min_size     = 1
      max_size     = 10
      labels = {
        Name = "eks-${include.env.locals.eks_cluster_name}-${include.env.locals.environment}-node"
      }

      iam_role_additional_policies = {
        policy = dependency.iam.outputs.policy_arn
      }
      tags = {
        Environment = "${include.env.locals.environment}"
        Terraform = "true"
        Name = "eks-${include.env.locals.environment}-node"
      }
    }
  }
  enable_cluster_creator_admin_permissions = true
  authentication_mode = "API_AND_CONFIG_MAP"
  access_entries = {
    cluster-admin = {
      principal_arn     = "arn:aws:iam::${include.env.locals.account_id}:user/User1"
      policy_associations = {
        cluster-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    },
  }  
  tags = {
    Environment = "${include.env.locals.eks_cluster_name}-${include.env.locals.environment}"
    Terraform = "true"
  }
}

dependency "iam" {
  config_path = "../iam/eks-nodegroup"
}

dependency "vpc" {
  config_path = "../vpc"
}