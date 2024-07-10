resource "yandex_compute_disk" "disk" {
  count = var.disk_count

  name = "disk-${count.index + 1}"
  type = "network-hdd"
  size = 1
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_web_image_family
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk[*].id
    content {
      disk_id = secondary_disk.value
    }
  }

  metadata = local.metadata
  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
     security_group_ids = toset([yandex_vpc_security_group.example.id])
  }
}
