output "external_ip_address" {
  value = yandex_compute_instance.node.*.network_interface.0.nat_ip_address
    
}

output "internal_ip_address" {
  value = yandex_compute_instance.node.*.network_interface.0.ip_address
    
}

resource "local_file" "AnsibleInventory" {
     content = templatefile("inventory.tmpl",
     {
            ext_ip = yandex_compute_instance.node.*.network_interface.0.nat_ip_address
            privat_key_path = var.privat_key_path
                    
     }
     )
        filename = "../ansible/inventory"
           
        
}
resource "local_file" "K8SInventory" {
     content = templatefile("hosts.ini.tmpl",
     {
            ext_ip = yandex_compute_instance.node.*.network_interface.0.nat_ip_address
            int_ip = yandex_compute_instance.node.*.network_interface.0.ip_address
                    
     }
     )
        filename = "../src/hosts.ini"
           
        
}
