terraform {
  source = "../../../../../../1-terraform_modules/aws/prod/iam/"
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
  policy_name        = "eks-nodegroup-${include.env.locals.environment}-${include.env.locals.prefix}"
  policy_description = "eks nodegroup custom IAM policy"
  policy_document    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "ec2:*",
          "Effect": "Allow",
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "ecr:GetDownloadUrlForLayer",
              "ecr:GetAuthorizationToken",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage"
          ],
          "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "eks:DescribeCluster",
        "Resource": "arn:aws:eks:${include.env.locals.region}:${include.env.locals.account_id}:cluster/${include.env.locals.eks_cluster_name}"
      }
  ]
}
EOF

  role_name = "eks-nodegroup-${include.env.locals.environment}-${include.env.locals.prefix}"
  role_tags = {
    Environment = "${include.env.locals.environment}"
    Terraform   = "true"
  }
}