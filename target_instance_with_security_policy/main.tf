resource "google_compute_network" "default" {
  provider                = google-beta
  name                    = "custom-default-network-${local.name_suffix}"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}
      
resource "google_compute_subnetwork" "default" {
  provider                   = google-beta
  name                       = "custom-default-subnet-${local.name_suffix}"
  ip_cidr_range              = "10.1.2.0/24"
  network                    = google_compute_network.default.id
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  region                     = "southamerica-west1"
  stack_type                 = "IPV4_ONLY"
}

data "google_compute_image" "vmimage" {
  provider = google-beta
  family   = "debian-11"
  project  = "debian-cloud"
}

resource "google_compute_instance" "target-vm" {
  provider     = google-beta
  name         = "target-vm-${local.name_suffix}"
  machine_type = "e2-medium"
  zone         = "southamerica-west1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.vmimage.self_link
    }
  }

  network_interface {       
    network = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.default.self_link
    access_config {
    }
  }
}

resource "google_compute_region_security_policy" "policyddosprotection" {
  provider    = google-beta
  region      = "southamerica-west1"
  name        = "tf-test-policyddos%{random_suffix}"
  description = "ddos protection security policy to set target instance"
  type        = "CLOUD_ARMOR_NETWORK"
  ddos_protection_config {
    ddos_protection = "ADVANCED_PREVIEW"
  }
}

resource "google_compute_network_edge_security_service" "edge_sec_service" {
  provider        = google-beta
  region          = "southamerica-west1"
  name            = "tf-test-edgesec%{random_suffix}"
  security_policy = google_compute_region_security_policy.policyddosprotection.self_link
}

resource "google_compute_region_security_policy" "regionsecuritypolicy" {
  provider    = google-beta
  name        = "region-secpolicy-${local.name_suffix}"
  region      = "southamerica-west1"
  description = "basic security policy for target instance"
  type        = "CLOUD_ARMOR_NETWORK"
  depends_on  = [google_compute_network_edge_security_service.edge_sec_service]
}

resource "google_compute_target_instance" "default" {
  provider        = google-beta
  name            = "target-instance-${local.name_suffix}"
  zone            = "southamerica-west1-a"
  instance        = google_compute_instance.target-vm.id
  security_policy = google_compute_region_security_policy.regionsecuritypolicy.self_link
}
