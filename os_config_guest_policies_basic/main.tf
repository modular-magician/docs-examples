data "google_compute_image" "my_image" {
  provider = google-beta
  family  = "debian-9"
  project = "debian-cloud"
}

resource "google_compute_instance" "foobar" {
  provider = google-beta
  name           = "guest-policy-inst-${local.name_suffix}"
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

resource "google_os_config_guest_policies" "guest_policies" {
  provider = google-beta
  guest_policy_id = "guest-policy-${local.name_suffix}"

  assignment {
    instances = [google_compute_instance.foobar.id]
  }

  packages {
    name = "my-package"
    desired_state = "UPDATED"
  }
}
