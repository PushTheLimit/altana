locals {
  resource_module = "nat_gateway"
  resource_name   = "${var.application}-${local.resource_module}"
}

module "eip" {
  source = "../eip"
  count  = length(var.nat_gateway_config)

  env         = var.env
  application = var.application
  identifier  = var.nat_gateway_config[count.index].nat_subnet_identifier
}

module "subnet" {
  source = "../subnet"
  count  = length(var.nat_gateway_config)

  env               = var.env
  application       = var.application
  vpc_id            = var.vpc_id
  identifier        = var.nat_gateway_config[count.index].nat_subnet_identifier
  cidr_block        = var.nat_gateway_config[count.index].subnet_cidr
  availability_zone = var.nat_gateway_config[count.index].availability_zone
}

resource "aws_nat_gateway" "selected" {
  count = length(var.nat_gateway_config)

  allocation_id = module.eip[count.index].selected_id
  subnet_id     = module.subnet[count.index].selected_id

  tags = {
    Env         = var.env
    Application = var.application
    Name        = local.resource_name
    Terraform   = true
  }

  depends_on = [module.eip, module.subnet]
}
