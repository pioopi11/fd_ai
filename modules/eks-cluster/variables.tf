variable "cluster_name" {
  description = "EKS cluster name; also used as a prefix for VPC, subnets and IAM roles"
  type        = string
}

variable "region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "kubernetes_version" {
  description = "Kubernetes version of the EKS control plane and node group"
  type        = string
  default     = "1.37"
}

variable "vpc_cidr" {
  description = "CIDR block of the cluster VPC; public subnets are /24 blocks carved from it, one per availability zone"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for public subnets (EKS requires at least 2)"
  type        = list(string)
  default     = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}

variable "instance_types" {
  description = "EC2 instance types of the node group; several types make spot capacity easier to get"
  type        = list(string)
  default     = ["t3.large", "t3a.large", "m5.large"]
}

variable "capacity_type" {
  description = "Node group capacity type: SPOT or ON_DEMAND"
  type        = string
  default     = "SPOT"
}

variable "node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 2
}

variable "node_disk_size" {
  description = "Root disk size of each node, GiB"
  type        = number
  default     = 20
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public Kubernetes API endpoint; an IAM token is required anyway"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "access_entries" {
  description = <<-EOT
    Extra IAM principals with access to the cluster. Map key is a free-form name.
    principal_arn     - IAM user or role ARN.
    kubernetes_groups - Kubernetes groups for your own RBAC bindings.
    policies          - EKS access policies by name (AmazonEKSClusterAdminPolicy, AmazonEKSAdminPolicy,
                        AmazonEKSEditPolicy, AmazonEKSViewPolicy); empty namespaces = cluster scope.
  EOT
  type = map(object({
    principal_arn     = string
    kubernetes_groups = optional(list(string), [])
    policies = optional(list(object({
      name       = string
      namespaces = optional(list(string), [])
    })), [])
  }))
  default = {}
}

variable "tags" {
  description = "Tags added to every resource the module creates"
  type        = map(string)
  default     = {}
}
