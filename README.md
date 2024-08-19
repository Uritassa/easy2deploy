# ***Welcome to E2D devOps Project 🚀***

### easy2deploy is a comprehensive DevOps mono repository project designed to build a fully automated infrastructure on AWS, with a specific focus on developer-friendly using Kubernetes. The goal is to provide a seamless, ready-to-use that accelerates application deployment, scaling, and management using Kubernetes.

### Requirements
#### Prerequisites
Before getting started, ensure the following:
IAM Policy and Role for GitHub Actions:
    Ensure that the IAM policies and roles required for GitHub Actions are already in place.
    Define which GitHub repository will use these permissions.

Environment-Specific Variables and Secrets:
    Define the necessary variables and secrets for each environment (e.g., dev, prod) within your GitHub repository.
    These include details like the environment name, working directory, region, and the necessary cloud provider and GitHub secrets.

### Technology stack include:
1. AWS as a cloud provider
2. Terraform and Terragrunt as a IaC tools
3. Kubernetes for container orchestration
4. Helm  
5. ArgoCD
6. AWS resources such as IAM, VPC, EKS, ALB, ACM, WAF, Route53
7. Monitoring and alerts with Kube-Prometheus-stack & Grafana