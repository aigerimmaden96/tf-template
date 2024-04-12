output "aws_account_role_arn" {
  value = var.aws_account_role_arn
}

output "eks_asg_arns" {
  value = module.eks.workers_asg_arns
}

output "eks_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "eks_name" {
  value = module.eks.name
}

output "eks_ca_cert" {
  value = module.eks.ca_cert
}

output "eks_endpoint" {
  value = module.eks.endpoint
}
