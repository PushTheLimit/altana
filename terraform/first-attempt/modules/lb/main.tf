locals {
  resource_module = "lb"
  resource_name   = "${var.application}-${local.resource_module}"
  subnet_map      = zipmap(var.eips, var.subnets)
}

resource "aws_lb" "selected" {
  name               = local.resource_name
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = local.subnet_map

    content {
      allocation_id = subnet_mapping.key
      subnet_id     = subnet_mapping.value
    }
  }

  tags = {
    Env         = var.env
    Application = var.application
    Name        = local.resource_name
    Terraform   = true
  }
}
