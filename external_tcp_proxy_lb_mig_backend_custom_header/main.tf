# External TCP proxy load balancer with managed instance group backend

# VPC
resource "google_compute_network" "default" {
  name                    = "tcp-proxy-xlb-network-${local.name_suffix}"
  provider                = google
  auto_create_subnetworks = false
}

# backend subnet
resource "google_compute_subnetwork" "default" {
  name          = "tcp-proxy-xlb-subnet-${local.name_suffix}"
  provider      = google
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.id
}

# reserved IP address
resource "google_compute_global_address" "default" {
  name = "tcp-proxy-xlb-ip-${local.name_suffix}"
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "tcp-proxy-xlb-forwarding-rule-${local.name_suffix}"
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "110"
  target                = google_compute_target_tcp_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

resource "google_compute_target_tcp_proxy" "default" {
  name            = "test-proxy-health-check-${local.name_suffix}"
  backend_service = google_compute_backend_service.default.id
}

# backend service
resource "google_compute_backend_service" "default" {
  name                  = "tcp-proxy-xlb-backend-service-${local.name_suffix}"
  protocol              = "TCP"
  port_name             = "tcp"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 1.0
    capacity_scaler = 1.0
  }
}

resource "google_compute_health_check" "default" {
  name               = "tcp-proxy-health-check-${local.name_suffix}"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}

# instance template
resource "google_compute_instance_template" "default" {
  name         = "tcp-proxy-xlb-mig-template-${local.name_suffix}"
  provider     = google
  machine_type = "e2-small"
  tags         = ["allow-health-check"]

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {
      # add external ip to fetch packages
    }
  }
  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
    boot         = true
  }

  # install nginx and serve a simple web page
  metadata = {
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq
      NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
      IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
      METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')
      cat <<EOF > /var/www/html/index.html
      <pre>
      Name: $NAME
      IP: $IP
      Metadata: $METADATA
      </pre>
      EOF
    EOF1
  }
  lifecycle {
    create_before_destroy = true
  }
}

# MIG
resource "google_compute_instance_group_manager" "default" {
  name     = "tcp-proxy-xlb-mig1-${local.name_suffix}"
  provider = google
  zone     = "us-central1-c"
  named_port {
    name = "tcp"
    port = 110
  }
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 2
}

# allow access from health check ranges
resource "google_compute_firewall" "default" {
  name          = "tcp-proxy-xlb-fw-allow-hc-${local.name_suffix}"
  provider      = google
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
