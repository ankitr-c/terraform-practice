resource "google_compute_instance" "tf_demo" {
  name           = "tf-demo-instance"
  machine_type   = var.machine_type
  zone           = var.default_zone
  tags           = ["port5000"]
  can_ip_forward = true
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    network = "default"
    access_config {

      # uncomment the below block of code to add static address. 
      # to add static external ip address you have to manually create and add the address
      ##   nat_ip = google_compute_address.external_ip.address
    }
  }

}

# code to create an static external ip address.
# uncomment the below code.
## resource "google_compute_address" "external_ip" {
##   name   = "external-ip"
##   region = var.region_name
## }


resource "google_compute_firewall" "port5000" {
  name          = "port5000"
  network       = "default"
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  allow {
    ports    = ["5000"]
    protocol = "tcp"
  }
}
