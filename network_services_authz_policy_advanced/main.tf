resource "google_compute_network" "default" {
  name                    = "lb-network-${local.name_suffix}"
  project                 = "PROJECT_NAME"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "backend-subnet-${local.name_suffix}"
  project       = "PROJECT_NAME"
  region        = "us-west1"
  ip_cidr_range = "10.1.2.0/24"
  network       = google_compute_network.default.id
}

resource "google_compute_subnetwork" "proxy_only" {
  name          = "proxy-only-subnet-${local.name_suffix}"
  project       = "PROJECT_NAME"
  region        = "us-west1"
  ip_cidr_range = "10.129.0.0/23"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.default.id
}

resource "google_compute_instance" "callouts_instance" {
  name                = "l7-ilb-callouts-ins-${local.name_suffix}"
  zone                = "us-west1-a"
  machine_type        = "e2-small"
  tags                = ["allow-ssh","load-balanced-backend"]
  deletion_protection = false

  labels = {
    "container-vm" = "cos-stable-109-17800-147-54"
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {
      # add external ip to fetch packages
    }

  }

  boot_disk {
    auto_delete  = true
    initialize_params {
      type  = "pd-standard"
      size  = 10
      image = "https://www.googleapis.com/compute/v1/projects/cos-cloud/global/images/cos-stable-109-17800-147-54"
    }
  }

  metadata = {
    gce-container-declaration = "# DISCLAIMER:\n# This container declaration format is not a public API and may change without\n# notice. Please use gcloud command-line tool or Google Cloud Console to run\n# Containers on Google Compute Engine.\n\nspec:\n  containers:\n  - image: us-docker.pkg.dev/service-extensions-samples/callouts/python-example-basic:main\n    name: callouts-vm\n    securityContext:\n      privileged: false\n    stdin: false\n    tty: false\n    volumeMounts: []\n  restartPolicy: Always\n  volumes: []\n"
    google-logging-enabled = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group" "callouts_instance_group" {
  name        = "l7-ilb-callouts-ins-group-${local.name_suffix}"
  description = "Terraform test instance group"
  zone        = "us-west1-a"

  instances = [
    google_compute_instance.callouts_instance.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "grpc"
    port = "443"
  }
}

resource "google_compute_region_health_check" "callouts_health_check" {
  name     = "l7-ilb-callouts-healthcheck-${local.name_suffix}"
  region   = "us-west1"

  http_health_check {
    port = 80
  }

  depends_on = [
    google_compute_region_health_check.default
  ]
}

resource "google_compute_address" "default" {
  name         = "l7-ilb-ip-address-${local.name_suffix}"
  project      = "PROJECT_NAME"
  region       = "us-west1"
  subnetwork   = google_compute_subnetwork.default.id
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_region_health_check" "default" {
  name    = "l7-ilb-basic-check-${local.name_suffix}"
  project = "PROJECT_NAME"
  region  = "us-west1"

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_region_backend_service" "url_map" {
  name                  = "l7-ilb-backend-service-${local.name_suffix}"
  project               = "PROJECT_NAME"
  region                = "us-west1"
  load_balancing_scheme = "INTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_url_map" "default" {
  name            = "l7-ilb-map-${local.name_suffix}"
  project         = "PROJECT_NAME"
  region          = "us-west1"
  default_service = google_compute_region_backend_service.url_map.id
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "l7-ilb-proxy-${local.name_suffix}"
  project = "PROJECT_NAME"
  region  = "us-west1"
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "l7-ilb-forwarding-rule-${local.name_suffix}"
  project               = "PROJECT_NAME"
  region                = "us-west1"
  load_balancing_scheme = "INTERNAL_MANAGED"
  network               = google_compute_network.default.id
  subnetwork            = google_compute_subnetwork.default.id
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  ip_address            = google_compute_address.default.id

  depends_on = [google_compute_subnetwork.proxy_only]
}

resource "google_compute_region_backend_service" "authz_extension" {
  name    = "authz-service-${local.name_suffix}"
  project = "PROJECT_NAME"
  region  = "us-west1"

  protocol              = "HTTP2"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_name             = "grpc"

  health_checks = [google_compute_region_health_check.callouts_health_check.id] 
  backend {
    group = google_compute_instance_group.callouts_instance_group.id
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_network_services_authz_extension" "default" {
  name     = "my-authz-ext-${local.name_suffix}"
  project  = "PROJECT_NAME"
  location = "us-west1"

  description           = "my description"
  load_balancing_scheme = "INTERNAL_MANAGED"
  authority             = "ext11.com"
  service               = google_compute_region_backend_service.authz_extension.self_link
  timeout               = "0.1s"
  fail_open             = false
  forward_headers       = ["Authorization"]
}

resource "google_network_security_authz_policy" "default" {
  name        = "my-authz-policy-${local.name_suffix}"
  project     = "PROJECT_NAME"
  location    = "us-west1"
  description = "my description"

  target {
    load_balancing_scheme = "INTERNAL_MANAGED"
    resources = [ google_compute_forwarding_rule.default.self_link ]
  }

  action = "CUSTOM"
  custom_provider {
    authz_extension {
      resources = [ google_network_services_authz_extension.default.id ]
    }
  }

  http_rules {
    from {
      not_sources {
        principals {
          exact = "dummy-principal"
        }
      }
    }
    to {
      operations {
        header_set {
          headers {
            name = "test-header"
            value {
              exact = "test-value"
              ignore_case = true
            }
          }
        }
      }
    }
  }
}
