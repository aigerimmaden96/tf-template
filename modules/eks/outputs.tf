output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
}

output "workers_asg_arns" {
  value = module.eks.workers_asg_arns
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "name" {
  value = module.eks.cluster_id
}

output "ca_cert" {
  value = module.eks.cluster_certificate_authority_data
}

output "endpoint" {
  value = module.eks.cluster_endpoint
}
