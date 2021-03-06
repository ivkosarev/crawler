provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
resource "yandex_compute_instance" "app" {
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }

  metadata = {
  #ssh-keys = "ubuntu:${file("~/.ssh/usr1.pub")}"
  ssh-keys = join("", ["ubuntu:", file(var.public_key_path)])
  }
  boot_disk {
    initialize_params {
  
      image_id = var.image_id
      size = 20
    }
  }

  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = var.subnet_id
    nat       = true
  }
  connection {
  type = "ssh"
  host = yandex_compute_instance.app[count.index].network_interface.0.nat_ip_address
  #host = yandex_compute_instance.app.network_interface.0.nat_ip_address
  user = "ubuntu"
  agent = false
  # путь до приватного ключа
  private_key = file(var.privat_key_path)
  }
  
  
}
