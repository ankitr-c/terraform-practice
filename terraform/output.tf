output "output_string" {
  value = join("", ["http://", google_compute_instance.tf_demo.network_interface[0].access_config[0].nat_ip, ":5000"])
}
