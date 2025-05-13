resource "google_compute_network" "my_network" {
  name = "wbi-test-default-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name   = "wbi-test-default-${local.name_suffix}"
  network = google_compute_network.my_network.id
  region = "us-central1"
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_address" "static" {
  name = "wbi-test-default-${local.name_suffix}"
}

resource "google_service_account_iam_binding" "act_as_permission" {
  service_account_id = "projects/PROJECT_NAME/serviceAccounts/SERVICE_ACCT"
  role               = "roles/iam.serviceAccountUser"
  members = [
    "user:example@example.com",
  ]
}

resource "google_workbench_instance" "instance" {
  name = "workbench-instance-${local.name_suffix}"
  location = "us-central1-a"

  gce_setup {
    machine_type = "n1-standard-4" // cant be e2 because of accelerator
    accelerator_configs {
      type         = "NVIDIA_TESLA_T4"
      core_count   = 1
    }

    shielded_instance_config {
      enable_secure_boot = true
      enable_vtpm = true
      enable_integrity_monitoring = true
    }

    disable_public_ip = false

    service_accounts {
      email = "SERVICE_ACCT"
    }

    boot_disk {
      disk_size_gb  = 310
      disk_type = "PD_SSD"
      disk_encryption = "CMEK"
      kms_key = "my-crypto-key-${local.name_suffix}"
    }

    data_disks {
      disk_size_gb  = 330
      disk_type = "PD_SSD"
      disk_encryption = "CMEK"
      kms_key = "my-crypto-key-${local.name_suffix}"
    }

    network_interfaces {
      network = google_compute_network.my_network.id
      subnet = google_compute_subnetwork.my_subnetwork.id
      nic_type = "GVNIC"
      access_configs {
        external_ip = google_compute_address.static.address
      }
    }

    metadata = {
      terraform = "true"
    }

    enable_ip_forwarding = true

    tags = ["abc", "def"]

  }

  disable_proxy_access = "true"

  instance_owners  = ["example@example.com"]

  labels = {
    k = "val"
  }

  desired_state = "ACTIVE"

  enable_third_party_identity = "true"

    depends_on = [
    google_compute_network.my_network,
    google_compute_subnetwork.my_subnetwork,
    google_compute_address.static,
    google_service_account_iam_binding.act_as_permission,
  ]
}
