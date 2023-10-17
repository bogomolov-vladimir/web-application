output "app_public_ip" {
  value = local.ifconfig_co_json.ip
}