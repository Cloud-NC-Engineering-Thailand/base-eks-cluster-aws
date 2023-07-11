

module "eks" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.29.0"
  cluster_version = "1.25"

  cluster_name = var.eks.cluster_name

  cluster_endpoint_private_access = var.eks.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.eks.cluster_endpoint_public_access

  vpc_id     = var.eks.vpc_id
  subnet_ids = var.eks.subnet_ids

  enable_irsa = var.eks.enable_irsa

  eks_managed_node_group_defaults = {
    disk_size = var.eks.disk_size
  }

  eks_managed_node_groups = var.eks_managed_node_groups

  manage_aws_auth_configmap = var.eks.manage_aws_auth_configmap
  aws_auth_roles            = var.eks.aws_auth_roles


  tags = {
    Environment = var.eks.env
  }
}

# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  # token                  = data.aws_eks_cluster_auth.default.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
    command     = "aws"
  }
}
