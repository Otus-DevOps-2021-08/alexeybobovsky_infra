output "subnet_id" {
  description = "ID of provisioned subnet"
  value       = yandex_vpc_subnet.app-subnet.id
}

