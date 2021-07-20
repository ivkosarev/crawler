output "external_ip_address" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
    
}
output "privat_key_path" {
  value = var.privat_key_path
    
}
#output "external_ip_balancer" {
# value = yandex_lb_network_load_balancer.balancer[0].listener.*.external_address_spec
#}


#output "external_ip_address_app" {
#value = yandex_compute_instance.app.network_interface.0.nat_ip_address
#}

resource "local_file" "AnsibleInventory" {
     content = templatefile("inventory.tmpl",
     {
            ext_ip = yandex_compute_instance.app.network_interface.0.nat_ip_address
            privat_key_path = var.privat_key_path
                    
     }
     )
        filename = "../ansible/inventory"
           
        
}

