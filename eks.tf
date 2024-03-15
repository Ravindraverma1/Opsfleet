module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.5.1"
  cluster_name    = local.prefix
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      configuration_values        = jsonencode(var.coredns_config)
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      service_account_role_arn = aws_iam_role.vpc_cni.arn
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  eks_managed_node_group_defaults = {
    ## This instance type (m6a.large) is a placeholder and will not be used in the actual deployment.
    instance_types = ["m6a.large"]
  }

  eks_managed_node_groups = var.eks_managed_node_groups

  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  enable_cluster_creator_admin_permissions = false

  access_entries = {
    for k in local.eks_access_entries : k.username => {
      kubernetes_groups = []
      principal_arn     = k.username
      policy_associations = {
        single = {
          policy_arn = k.access_policy
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = local.default_tags
}
