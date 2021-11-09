variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable subnet_id {
  description = "Subnet"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base-a"
}
variable app_cores {
  description = "Core number"
  default = "2"
}
variable app_memory {
  description = "Memory in Gb"
  default = "2"
}
variable app_name {
  description = "Instance name"
  default = "reddit-app"
}
variable app_tags {
  description = "Instance tag"
  default = "reddit-app"
}

