resource "yandex_compute_instance" "db" {
  for_each   = {
    for index, vm in var.each_vm:
    vm.vm_name => vm
  }
  name = each.value.vm_name
  hostname    = each.value.vm_name
  platform_id = "standard-v1"

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_web_image_family
      size     = each.value.disk_volume
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