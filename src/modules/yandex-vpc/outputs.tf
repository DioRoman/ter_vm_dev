output "network_id" {
  description = "ID созданной VPC сети"
  value       = yandex_vpc_network.network.id
}

output "network_name" {
  description = "Имя созданной VPC сети"
  value       = yandex_vpc_network.network.name
}

output "subnet_ids" {
  description = "Map ID созданных подсетей по зонам"
  value = [for subnet in yandex_vpc_subnet.subnets : subnet.id]
}

output "security_group_id" {
  description = "ID созданной группы безопасности"
  value       = yandex_vpc_security_group.main.id
}