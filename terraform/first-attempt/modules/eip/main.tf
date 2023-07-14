locals {
  resource_module     = "eip"
  resource_name       = "${var.application}-${local.resource_module}"
  resource_identifier = var.identifier
}

resource "aws_eip" "selected" {

  tags = {
    Env         = var.env
    Application = var.application
    Name        = "${local.resource_name}-${local.resource_identifier}"
    Terraform   = true
  }
}
