
// for provider.tf
provider_aws = {
  access_key = "AKIAR25PCEOZVEFOO5YL"
  secret_key = "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"
}


// for vpc.tf
network = {
  name                   = "main"
  cidr                   = "10.0.0.0/16"
  availability_zones     = ["us-east-1a", "us-east-1b"]
  private_subnets        = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets         = ["10.0.64.0/19", "10.0.96.0/19"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
  tags_env               = "staging"
}


# for iam.tf
# Note: Name should not be duplicate
iam = [
  {
    # module iam_user
    user                          = ["admin1", "admin2"],
    create_iam_access_key         = false
    create_iam_user_login_profile = false
    force_destroy                 = true

    # module iam_group
    iam_group_name                    = "eks-admin"
    attach_iam_self_management_policy = false
    create_group                      = true

    # allow_eks_access
    name_eks_access         = "allow-eks-admin-access"
    allow_eks_access_action = ["eks:DescribeNodegroup", "eks:DescribeCluster"]
    effect                  = "Allow"
    resource                = "*"

    # iam_role
    role_name         = "eks-admin"
    create_role       = true
    role_requires_mfa = false

    # allow_assume_eks_iam_policy
    allow_assume_name = "allow-assume-eks-admin-iam-role"
    create_policy     = true
  },
  {
    # module iam_user
    user                          = ["dev1", "dev2"],
    create_iam_access_key         = false
    create_iam_user_login_profile = false
    force_destroy                 = true

    # module iam_group
    iam_group_name                    = "eks-dev"
    attach_iam_self_management_policy = false
    create_group                      = true

    # allow_eks_access
    name_eks_access         = "allow-eks-dev-access"
    allow_eks_access_action = ["eks:ListNodeGroups", "eks:ListClusters", "eks:DescribeNodegroup", "eks:DescribeCluster"]
    effect                  = "Allow"
    resource                = "*"

    # iam_role
    role_name         = "eks-dev"
    create_role       = true
    role_requires_mfa = false

    # allow_assume_eks_iam_policy
    allow_assume_name = "allow-assume-eks-dev-iam-role"
    create_policy     = true
  },

]
