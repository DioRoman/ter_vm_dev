output "clickhouse_vm_ips" {
  description = "Public IP addresses of ClickHouse VMs"
  value       = module.yandex-vm.external_ips
}

output "clickhouse_vm_private_ips" {
  description = "Private IP addresses of ClickHouse VMs"
  value       = module.yandex-vm.internal_ips
}