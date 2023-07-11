resource "kubernetes_role" "example" {
  
  count = length(var.kube_role)

  metadata {
    name = var.kube_role[count.index].metadata.name
    namespace = var.kube_role[count.index].metadata.namespace
  }

  rule {
    api_groups = var.kube_role[count.index].rule.api_groups
    resources  = var.kube_role[count.index].rule.resources
    verbs      = var.kube_role[count.index].rule.verbs
  }
}

resource "kubernetes_role_binding_v1" "example" {

  count = length(var.kube_role_binding)

  metadata {
    name = var.kube_role_binding[count.index].metadata.name
    namespace = var.kube_role_binding[count.index].metadata.namespace
  }
  role_ref {
    api_group = var.kube_role_binding[count.index].role_ref.api_group
    kind      = var.kube_role_binding[count.index].role_ref.kind
    name      = var.kube_role_binding[count.index].role_ref.name
  }
  subject {
    api_group = var.kube_role_binding[count.index].subject.api_group
    kind      = var.kube_role_binding[count.index].subject.kind
    name      = var.kube_role_binding[count.index].subject.name
  }
}