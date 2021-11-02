variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "key .json"
}
variable private_key_path {
  description = "Path to the private key used for provision connection"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
variable app_tags {
  description = "App VM tags"
}
variable app_name {
  description = "App VM name"
}
variable app_cores {
  description = "App cores sum"
}
variable app_memory {
  description = "App memory sum"
}
variable db_tags {
  description = "DB VM tags"
}
variable db_name {
  description = "DB VM name"
}
variable db_cores {
  description = "App cores sum"
}
variable db_memory {
  description = "App memory sum"
}
