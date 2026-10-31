output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "region" {
  description = "AWS region of the cluster"
  value       = var.region
}

output "kubeconfig_command" {
  description = "Command that adds the cluster context to ~/.kube/config"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.this.name}"
}
