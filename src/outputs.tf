output "clickhouse_vm_ips" {
  description = "Public IP addresses of ClickHouse VMs"
  value       = module.clickhouse-vm.external_ips
}

output "clickhouse_vm_private_ips" {
  description = "Private IP addresses of ClickHouse VMs"
  value       = module.clickhouse-vm.internal_ips
}

output "vector_vm_ips" {
  description = "Public IP addresses of ClickHouse VMs"
  value       = module.vector-vm.external_ips
}

output "vector_vm_private_ips" {
  description = "Private IP addresses of ClickHouse VMs"
  value       = module.vector-vm.internal_ips
}