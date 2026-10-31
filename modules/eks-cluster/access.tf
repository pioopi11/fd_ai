locals {
  access_policy_associations = merge([
    for entry_key, entry in var.access_entries : {
      for policy in entry.policies : "${entry_key}/${policy.name}" => {
        entry_key  = entry_key
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/${policy.name}"
        namespaces = policy.namespaces
      }
    }
  ]...)
}

resource "aws_eks_access_entry" "this" {
  for_each = var.access_entries

  cluster_name      = aws_eks_cluster.this.name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = each.value.kubernetes_groups
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "this" {
  for_each = local.access_policy_associations

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = aws_eks_access_entry.this[each.value.entry_key].principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type       = length(each.value.namespaces) > 0 ? "namespace" : "cluster"
    namespaces = length(each.value.namespaces) > 0 ? each.value.namespaces : null
  }
}
