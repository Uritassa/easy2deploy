terraform {
    source = "../../../../../../1-terraform_modules/aws/dev/ecr"
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
    ecr_repo_name = "projectx-${include.env.locals.environment}"
    tags = {
        Name = "projectx-${include.env.locals.environment}"
        Environment = include.env.locals.environment
        Terraform = "true"
    }
}

