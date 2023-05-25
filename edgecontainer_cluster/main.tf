resource "google_edgecontainer_cluster" "default" {
  name = "basic-cluster-${local.name_suffix}"
  location   = "us-central1"

  authorization {
    admin_users {
      username = "admin@hashicorptest.com"
    }
  }

  networking {
    cluster_ipv4_cidr_blocks = ["10.0.0.0/16"]
    services_ipv4_cidr_blocks = ["10.1.0.0/16"]
  }
  
  fleet {
    project = "projects/${data.google_project.project.number}"
  }
}

data "google_project" "project" {}
