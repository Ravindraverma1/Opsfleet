## Versions

1. TF_VERSION = 1.3.9
2. KUBERNETES_VERSION = 1.29
3. AWS_CLI_VERSION = > 2.0.0

##  Outputs:
![k8s1](docs/cluster-creation.png)
![k8s2](docs/console-cluster.png)
![k8s3](docs/namespace-pod-s3-access.png)
![k8s4](docs/oidc.png)
![k8s5](docs/s3-policy.png)
![k8s6](docs/s3.png)

## Steps to create AWS Eks cluster.

1. Fill  the respective values in the terraform.tfvars
2. terraform init
3. terraform plan
4. terraform apply

