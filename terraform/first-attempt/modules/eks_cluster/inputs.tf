variable "env" {
  type = string
}

variable "application" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "endpoint_private_access" {
  type = bool
}

variable "endpoint_public_access" {
  type = bool
}

variable "kubernetes_version" {
  type = string
}
