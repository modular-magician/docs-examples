resource "google_network_management_connectivity_test" "forwarding-rule-test" {
  name = "forwarding-rule-test-${local.name_suffix}"
  source {
    forwarding_rule = google_compute_forwarding_rule.source.id
  }

  destination {
    forwarding_rule = google_compute_forwarding_rule.dest.id
  }

  protocol = "TCP"
  labels = {
    env = "test"
  }
}

resource "google_compute_target_pool" "source" {
  name = "src-forwarding-rule-${local.name_suffix}"
}

resource "google_compute_forwarding_rule" "source" {
  name        = "src-forwarding-rule-${local.name_suffix}"
  target     = google_compute_target_pool.source.id
  port_range = "80"
}

resource "google_compute_target_pool" "dest" {
  name = "src-forwarding-rule-${local.name_suffix}"
}

resource "google_compute_forwarding_rule" "dest" {
  name        = "src-forwarding-rule-${local.name_suffix}"
  target     = google_compute_target_pool.dest.id
  port_range = "80"
}
