resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.db]
  count = var.instance_count
  name = "web-${count.index + 1}"
  
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

  metadata = local.metadata
  scheduling_policy { preemptible = true }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = toset([yandex_vpc_security_group.example.id])
  }  
}