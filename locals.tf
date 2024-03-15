data "aws_caller_identity" "current" {}
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

locals {
  project    = "test"
  prefix     = "${local.project}-${var.env}-${var.region}"
  account_id = data.aws_caller_identity.current.account_id
  eks_access_policy = {
    viewer = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy",
    admin  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  }
  eks_access_entries = flatten([for k, v in var.eks_access_entries : [for s in v.user_arn : { username = s, access_policy = lookup(local.eks_access_policy, k), group = k }]])
  default_tags = {
    environment = var.env
    managed_by  = "terraform"
    project     = local.project
  }
}
