output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.private_subnets
}

output "rolearn" {
  value = module.eks_iam_role.*.iam_role_arn
}

output "rolename" {
    value = module.eks_iam_role.*.iam_role_name
}
