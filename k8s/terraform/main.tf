terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_compute_disk" "disk-master" {
  count = var.count_instance
  name     = "master-${count.index}"
  
  type     = "network-ssd"
  zone     = "ru-central1-a"
  size     = 7

  labels = {
    environment = "ssd1"
                
  }
}

resource "yandex_compute_disk" "disk-data" {
  count = var.count_instance
  name     = "data-${count.index}"
  
  type     = "network-ssd"
  zone     = "ru-central1-a"
  size     = 35

  labels = {
    environment = "ssd2"
                
  }
}

resource "yandex_compute_instance" "node" {
  count = var.count_instance
  name     = "node-${count.index}"

  resources {
    cores         = 4
    memory        = 8
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
  secondary_disk {
    disk_id = yandex_compute_disk.disk-master[count.index].id
    mode = "READ_WRITE"
  }
  secondary_disk {
    disk_id = yandex_compute_disk.disk-data[count.index].id
    mode = "READ_WRITE"
  }

  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = var.subnet_id
    nat       = true
  }
  
}
