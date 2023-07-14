variable "env" {
  type = string
}

variable "application" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "internet_gateway_name" {
  type = string
}

variable "nat_gateway_config" {
  type = list(object({
    availability_zone     = string
    nat_subnet_identifier = string
    subnet_cidr           = string
  }))
}
