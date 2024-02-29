# ----------------------DEPLOYING VM and FIREWALL RULE---------------------------


resource "google_compute_instance" "tf_demo" {
  name           = "tf-demo-instance"
  machine_type   = var.machine_type
  zone           = var.default_zone
  tags           = ["port5000", "http-server", "https-server"]
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
  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y"

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


# --------------------DEPLOYING A BUCKET AND STATIC OBJECTS---------------------------

resource "google_storage_bucket" "bucket" {
  name     = "ankitr2912-test"
  location = "us-east4"
}

resource "google_storage_default_object_access_control" "website_read" {
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_object" "object" {
  name   = "index.html"
  source = "../project/index.html"
  bucket = google_storage_bucket.bucket.name
}

# ----------------------------------------------------------------------------
