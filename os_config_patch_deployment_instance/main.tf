data "google_compute_image" "my_image" {
  family  = "debian-9"
  project = "debian-cloud"
}

resource "google_compute_instance" "foobar" {
  name           = "patch-deploy-inst-${local.name_suffix}"
  machine_type   = "e2-medium"
  zone           = "us-central1-a"
  can_ip_forward = false
  tags           = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network = "default"
  }

  metadata = {
    foo = "bar"
  }
}

resource "google_os_config_patch_deployment" "patch" {
  patch_deployment_id = "patch-deploy-inst-${local.name_suffix}"

  instance_filter {
    instances = [google_compute_instance.foobar.id]
  }

  patch_config {
    yum {
      security = true
      minimal = true
      excludes = ["bash"]
    }
  }

  recurring_schedule {
    time_zone {
      id = "America/New_York"
    }

    time_of_day {
      hours = 0
      minutes = 30
      seconds = 30
      nanos = 20
    }

    monthly {
      month_day = 1
    }
  }
}
