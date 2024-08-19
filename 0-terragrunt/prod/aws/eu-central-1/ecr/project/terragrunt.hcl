terraform {
    source = "../../../../../../1-terraform_modules/aws/prod/ecr"
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
    ecr_repo_name = "vulnerability_k8s_agent-${include.env.locals.environment}"
    tags = {
        Name = "vulnerability_k8s_agent-${include.env.locals.environment}"
        Environment = include.env.locals.environment
        Terraform = "true"
    }
}

