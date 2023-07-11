
// for provider.tf
provider_aws = {
  access_key = ""
  secret_key = ""
}


// for eks.tf nodegroup
// https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.29.0/submodules/eks-managed-node-group
eks_managed_node_groups = {
  general = {

    desired_size = 0
    min_size     = 0
    max_size     = 1

    labels = {
      role = "general"
    }

    instance_types = ["t3.small"]
    capacity_type  = "ON_DEMAND"

  }

  # spot = {
  #   desired_size = 0
  #   min_size     = 0
  #   max_size     = 1

  #   labels = {
  #     role = "spot"
  #   }

  #   taints = [{
  #     key    = "market"
  #     value  = "spot"
  #     effect = "NO_SCHEDULE"
  #   }]

  #   instance_types = ["t3.micro"]
  #   capacity_type  = "SPOT"
  # }
}

// for eks.tf
eks = {
  cluster_name                    = "my-eks",
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = "vpc-09f523ce4966ef9cd"
  subnet_ids = ["subnet-031805b771af46316", "subnet-0213a7cd59f200799"]

  enable_irsa = true

  disk_size                 = 20
  manage_aws_auth_configmap = true



  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::126531806131:role/eks-admin"
      username = "eks-admin"
      //Grant all kube access
      groups = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::126531806131:role/eks-dev"
      username = "eks-dev"
      //This group name should match the name in kube_role.metadata.name
      groups = ["read-only"]
    },
  ]

  env = "staging"

}

// for kubenetes.tf
kube_role = [
  {
    metadata = {
      name      = "read-only"
      namespace = "default"
    }

    rule = {
      api_groups = ["*"]
      resources  = ["*"]
      verbs      = ["get", "list", "watch"]
    }
  }
]

// for kubenetes.tf
kube_role_binding = [
  {
    metadata = {
      name      = "read-only-binding"
      namespace = "default"
    }

    role_ref = {
      api_group = "rbac.authorization.k8s.io"
      kind      = "Role"
      name      = "read-only"
    }
    subject = {
      api_group = "rbac.authorization.k8s.io"
      kind      = "Group"
      name      = "read-only"
    }
  }
]
