variable "env" {
  type = string
}

variable "application" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "nat_gateway_config" {
  type = list(object({
    availability_zone     = string
    nat_subnet_identifier = string
    subnet_cidr           = string
  }))
}

variable "eks_cluster_config" {
  type = object({
    kubernetes_version      = string
    endpoint_private_access = bool
    endpoint_public_access  = bool
  })
}

variable "eks_node_group_config" {
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}
