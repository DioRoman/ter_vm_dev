# ClickHouse outputs
output "clickhouse_vm_private_ips" {
  description = "Private IP addresses of ClickHouse VMs"
  value       = module.clickhouse-vm.internal_ips
}

output "clickhouse_ssh" {
  description = "SSH commands to connect to ClickHouse VMs"
  value = [
    for ip in module.clickhouse-vm.external_ips : "ssh -l ubuntu ${ip}"
  ]
}

# Vector outputs
output "vector_vm_private_ips" {
  description = "Private IP addresses of Vector VMs"
  value       = module.vector-vm.internal_ips
}

output "vector_ssh" {
  description = "SSH commands to connect to Vector VMs"
  value = [
    for ip in module.vector-vm.external_ips : "ssh -l ubuntu ${ip}"
  ]
}

# Lighthouse outputs
output "lighthouse_vm_private_ips" {
  description = "Private IP addresses of Lighthouse VM"
  value       = module.lighthouse-vm.internal_ips
}

output "lighthouse_ssh" {
  description = "SSH command to connect to Lighthouse VM"
  value = [
    for ip in module.lighthouse-vm.external_ips : "ssh -l ubuntu ${ip}"
  ]
}