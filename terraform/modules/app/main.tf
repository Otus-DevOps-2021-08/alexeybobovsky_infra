resource "yandex_compute_instance" "app" {
  name = var.app_name

  labels = {
    tags = var.app_tags
  }

  resources {
    cores  = var.app_cores
    memory = var.app_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat = true
  }

  metadata = {
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
