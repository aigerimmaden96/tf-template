module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "16.2.0"

  cluster_name    = "${var.environment}-eks"
  cluster_version = var.eks_version

  subnets                               = var.private_subnets
  vpc_id                                = var.vpc_id
  cluster_endpoint_private_access       = var.api_private_access
  cluster_endpoint_private_access_cidrs = var.private_api_access_cidrs
  cluster_endpoint_public_access        = var.api_public_access

  attach_worker_cni_policy = true  # TODO: replace with serviceaccount IAM role
  iam_path                 = "/eks/${var.environment}/"
  manage_aws_auth          = var.manage_aws_auth
  enable_irsa              = true

  write_kubeconfig   = true
  config_output_path = "${path.cwd}/kubeconfig.yaml"

  worker_ami_name_filter   = var.worker_ami_name_filter
  worker_groups = [
    {
      instance_type        = var.instance_type
      asg_max_size         = var.asg_max
      asg_min_size         = var.asg_min
      asg_desired_capacity = var.asg_desired
      tags = [
        {
          key                 = "Environment"
          value               = var.environment
          propagate_at_launch = true
        },
        {
          key                 = "k8s.io/cluster-autoscaler/${var.environment}-eks"
          value               = "owned"
          propagate_at_launch = true
        },
        {
          key                 = "k8s.io/cluster-autoscaler/enabled"
          value               = var.autoscaling ? "TRUE" : "FALSE"
          propagate_at_launch = true
        },
      ]
    },
  ]
  workers_additional_policies = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonMSKReadOnlyAccess",
  ]

  tags = {
    Environment = var.environment
  }
}

data "aws_eks_cluster" "eks" {
  name  = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name  = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
