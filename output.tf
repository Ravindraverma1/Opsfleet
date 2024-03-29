output "eks_cluster_version" {
  value = module.eks.cluster_version
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}
