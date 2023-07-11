
variable "provider_aws" {
    type = object({
      access_key = string
      secret_key = string 
    })
}

variable "eks" {
  type = object({
    cluster_name                      = string
    cluster_endpoint_private_access   = bool
    cluster_endpoint_public_access    = bool
    vpc_id                            = string
    subnet_ids                        = list(string)
    enable_irsa                       = bool
    disk_size                         = number
    manage_aws_auth_configmap         = bool
    aws_auth_roles                    = list(object({
      rolearn   = string
      username  = string
      groups    = list(string)
    }))
    env                               = string
  })
}

variable "eks_managed_node_groups" {
  type = any
  default = {}
}

variable "kube_role" {
  type = list(object({
    metadata = object({
      name      = string
      namespace = string
    })
    rule = object({
      api_groups = list(string)
      resources  = list(string)
      verbs      = list(string)
    })
  }))
}

variable "kube_role_binding" {
  type = list(object({
    metadata = object({
      name      = string
      namespace = string
    })
    role_ref = object({
      api_group = string
      kind      = string
      name      = string
    })
    subject = object({
      kind      = string
      name      = string
      api_group = string
    })
  }))
}
