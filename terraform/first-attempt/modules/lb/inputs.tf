variable "env" {
  type = string
}

variable "application" {
  type = string
}

variable "eips" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}
