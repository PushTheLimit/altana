variable "env" {
  type = string
}

variable "application" {
  type = string
}

variable "aws_eks_cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_node_group_config" {
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}
