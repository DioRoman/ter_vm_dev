# output "external_ip_address" {
#   value = yandex_compute_instance.vm.*.network_interface.0.nat_ip_address
# }

# output "internal_ip_address" {
#   value = yandex_compute_instance.vm.*.network_interface.0.ip_address
# }

# output "fqdn" {
#   value = yandex_compute_instance.vm.*.fqdn
# }

# output "labels" {
#   value = yandex_compute_instance.vm.*.labels
# }

# output "network_interface" {
#   value = yandex_compute_instance.vm.*.network_interface
# }
output "instance_ids" {
  description = "Список ID созданных виртуальных машин"
  value       = yandex_compute_instance.vm[*].id
}

output "instance_names" {
  description = "Список имен созданных виртуальных машин"
  value       = yandex_compute_instance.vm[*].name
}

output "external_ips" {
  description = "Список внешних IP-адресов"
  value       = yandex_compute_instance.vm[*].network_interface.0.nat_ip_address
}

output "internal_ips" {
  description = "Список внутренних IP-адресов"
  value       = yandex_compute_instance.vm[*].network_interface.0.ip_address
}

output "fqdn" {
  description = "Список FQDN созданных виртуальных машин"
  value = [for vm in yandex_compute_instance.vm : 
    try(vm.network_interface[0].dns_record[0].fqdn, null)
  ]
}

output "network_interfaces" {
  description = "Список сетевых интерфейсов ВМ"
  value       = yandex_compute_instance.vm[*].network_interface
}

output "boot_disks" {
  description = "Список загрузочных дисков ВМ"
  value       = yandex_compute_instance.vm[*].boot_disk
}
