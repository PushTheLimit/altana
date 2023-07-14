output "subnet_ids" {
  value = module.subnet[*].selected_id
}
