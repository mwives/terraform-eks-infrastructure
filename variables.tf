variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "fullcycle"
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "eks-cluster"
}

variable "retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}

variable "eks_node_desired_capacity" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 2
}

