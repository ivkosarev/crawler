provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
resource "yandex_compute_instance" "app" {
  count = var.instances_count
  name  = "crawler${count.index}"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  metadata = {
  #ssh-keys = "ubuntu:${file("~/.ssh/usr1.pub")}"
  ssh-keys = join("", ["ubuntu:", file(var.public_key_path)])
  }
  boot_disk {
    initialize_params {
  
      image_id = var.image_id
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
  password = var.password
  agent = false
  
  private_key = file("./usr1")
  }
  
  provisioner "file" {
   source = "./install_docker_compose.sh"
   destination = "/home/ubuntu/install_docker_compose.sh"
  }
  provisioner "remote-exec" {
  inline = ["chmod +x /home/ubuntu/install_docker_compose.sh",
    "sudo bash /home/ubuntu/install_docker_compose.sh",
    "git clone https://github.com/ivkosarev/crawler.git",
    "cd crawler/docker/ && sudo docker-compose up"
  ]
  }
  
}