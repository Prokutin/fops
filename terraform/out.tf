output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "web_private_ips" {
  value = yandex_compute_instance.web[*].network_interface[0].ip_address
}

output "prometheus_ip" {
  value = yandex_compute_instance.prometheus.network_interface[0].ip_address
}

output "grafana_ip" {
  value = yandex_compute_instance.grafana.network_interface[0].nat_ip_address
}

output "grafana_private_ip" {
  value = yandex_compute_instance.grafana.network_interface[0].ip_address
}

output "alb_external_ip" {
  value = yandex_alb_load_balancer.web.listener[0].endpoint[0].address[0].external_ipv4_address
}

output "elasticsearch_ip" {
  value = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
}

output "kibana_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
}

output "kibana_private_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].ip_address
}

resource "local_file" "inventory" {
  content  = <<-XYZ
  [web]
  web1 ansible_host=${yandex_compute_instance.web[0].network_interface.0.ip_address}
  web2 ansible_host=${yandex_compute_instance.web[1].network_interface.0.ip_address}

  [prometheus]
  prometheus ansible_host=${yandex_compute_instance.prometheus.network_interface[0].ip_address}

  [grafana]
  grafana ansible_host=${yandex_compute_instance.grafana.network_interface[0].ip_address}

  [elasticsearch]
  elasticsearch ansible_host=${yandex_compute_instance.elasticsearch.network_interface[0].ip_address}

  [kibana]
  kibana ansible_host=${yandex_compute_instance.kibana.network_interface[0].ip_address} public_ip=${yandex_compute_instance.kibana.network_interface[0].nat_ip_address}

  [all:vars]
  ansible_user=dvp
  ansible_ssh_private_key_file=~/.ssh/id_ed25519
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q dvp@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
  ansible_ssh_common_args=-o ProxyJump="dvp@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"
  XYZ
  filename = "./ansible/inventory/hosts.ini"
}