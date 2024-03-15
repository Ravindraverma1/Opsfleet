# Global variables
region             = "us-east-1"
env                = "dev"
vpc_id             = "vpc-0371f81a7b0d960a8"
vpc_cidr           = "172.31.0.0/16"
public_subnet_ids  = ["subnet-022373c39118fb0b7", "subnet-09ce8c31f601393ad"]
private_subnet_ids = ["subnet-0ef372c1b63dd08ae", "subnet-01fd73ae94f29f8e2"]
cluster_version    = "1.29"

# EKS variables
eks_managed_node_groups = {
  system-workload = { # ingress controller, coredns, aws-node, aws-ebs-csi-driver
    min_size       = 2
    max_size       = 2
    desired_size   = 2
    instance_types = ["t3a.large"]
    capacity_type  = "SPOT"
    disk_size      = 50
    ebs_optimized  = true
    iam_role_additional_policies = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
    labels = {
      workload = "system"
    }
    taints = [
      {
        key    = "workload"
        value  = "system"
        effect = "NO_SCHEDULE"
      }
    ]
  }
  dev = { # application workload
    min_size       = 0
    max_size       = 2
    desired_size   = 1
    instance_types = ["t3a.large"]
    capacity_type  = "SPOT"
    disk_size      = 50
    ebs_optimized  = true
  }
}
cluster_security_group_additional_rules = {}
#IAM USER & ROLE ARN BOTH ARE ACCEPTED IN VIEWER & ADMIN SECTION
eks_access_entries = {
  viewer = {
    user_arn = []
  }
  admin = {
    user_arn = ["arn:aws:iam::434605749312:user/ravindra-singh"]
  }
}
# EKS Addons variables 
coredns_config = {
  replicaCount = 1,
  tolerations : [
    {
      key : "workload",
      value : "system",
      effect : "NoSchedule"
    }
  ]
}