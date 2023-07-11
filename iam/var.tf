variable "iam" {
  type = list(object({
    user                              = list(string)
    create_iam_access_key             = bool
    create_iam_user_login_profile     = bool
    force_destroy                     = bool
    iam_group_name                    = string
    attach_iam_self_management_policy = bool
    create_group                      = bool
    name_eks_access                   = string
    allow_eks_access_action           = list(string)
    effect                            = string
    resource                          = string
    role_name                         = string
    create_role                       = bool
    role_requires_mfa                 = bool
    allow_assume_name                 = string
    create_policy                     = bool
  }))
  default = [{
    user                              = ["admin1"],
    create_iam_access_key             = false
    create_iam_user_login_profile     = false
    force_destroy                     = true
    iam_group_name                    = "eks-admin"
    attach_iam_self_management_policy = false
    create_group                      = true
    name_eks_access                   = "allow-eks-access"
    allow_eks_access_action           = ["eks:DescribeNodegroup", "eks:DescribeCluster"]
    effect                            = "Allow"
    resource                          = "*"
    role_name                         = "eks-admin"
    create_role                       = true
    role_requires_mfa                 = false
    allow_assume_name                 = "allow-assume-eks-admin-iam-role"
    create_policy                     = true
  }]
}

variable "provider_aws" {
  type = object({
    access_key = string
    secret_key = string
  })
}

variable "network" {
  type = object({
    version                = string
    name                   = string
    cidr                   = string
    availability_zones     = list(string)
    private_subnets        = list(string)
    public_subnets         = list(string)
    enable_nat_gateway     = bool
    single_nat_gateway     = bool
    one_nat_gateway_per_az = bool
    enable_dns_hostnames   = bool
    enable_dns_support     = bool
    tags_env               = string
  })
  default = {
    version                = "3.14.3"
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
}
