# [START networkmanagement_test_cloudrun_v2]
resource "google_network_management_connectivity_test" "cloudrun-v2-test" {
  name = "cloudrun-v2-test-${local.name_suffix}"
  source {
    cloud_run_revision {
      uri = google_cloud_run_v2_service.source.id
    } 
  }

  destination {
    cloud_run_revision {
      uri = google_cloud_run_v2_service.dest.id
    } 
  }

  protocol = "TCP"
  labels = {
    env = "test"
  }
}

resource "google_compute_network" "vpc" {
  name = "connectivity-vpc-${local.name_suffix}"
}

resource "google_cloud_run_v2_service" "source" {
  name     = "src-cloudrun-v2-${local.name_suffix}"
  location = "us-central1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    
    vpc_access {
      network_interfaces {
        network = google_compute_network.vpc.id
      }
    }
  }
}

resource "google_cloud_run_v2_service" "dest" {
  name     = "dest-cloudrun-v2-${local.name_suffix}"
  location = "us-central1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }

    vpc_access {
      network_interfaces {
        network = google_compute_network.vpc.id
      }
    }
  }
}
# [END networkmanagement_test_cloudrun_v2]
