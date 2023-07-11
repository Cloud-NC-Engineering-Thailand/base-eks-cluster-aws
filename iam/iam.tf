
locals {
  iam_create_user = flatten([for iam_config in var.iam : iam_config.user])
}
module "create_iam_user" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  count = length(local.iam_create_user)

  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.3.1"

  name                          = local.iam_create_user[count.index]
  create_iam_access_key         = false
  create_iam_user_login_profile = false

  force_destroy = true
}



module "eks_iam_group" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  count = length(var.iam)

  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.3.1"

  name                              = var.iam[count.index].iam_group_name
  attach_iam_self_management_policy = var.iam[count.index].attach_iam_self_management_policy
  create_group                      = var.iam[count.index].create_group
  group_users                       = var.iam[count.index].user
  custom_group_policy_arns          = [module.allow_assume_eks_iam_policy[count.index].arn]
}

module "allow_eks_access_iam_policy" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  count = length(var.iam)

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.3.1"

  name          = var.iam[count.index].name_eks_access
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.iam[count.index].allow_eks_access_action
        Effect   = var.iam[count.index].effect
        Resource = var.iam[count.index].resource
      },
    ]
  })
}
module "eks_iam_role" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  count = length(var.iam)

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.3.1"

  role_name         = var.iam[count.index].role_name
  create_role       = var.iam[count.index].create_role
  role_requires_mfa = var.iam[count.index].role_requires_mfa

  custom_role_policy_arns = [module.allow_eks_access_iam_policy[count.index].arn]

  trusted_role_arns = [
    "arn:aws:iam::${module.vpc.vpc_owner_id}:root"
  ]
}


module "allow_assume_eks_iam_policy" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  count = length(var.iam)


  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.3.1"

  name          = var.iam[count.index].allow_assume_name
  create_policy = var.iam[count.index].create_policy

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = module.eks_iam_role[count.index].iam_role_arn
      },
    ]
  })
}
