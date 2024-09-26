resource "google_network_connectivity_hub" "basic_hub"  {
 name        = "hub1-${local.name_suffix}"
 description = "A sample hub"
 labels = {
    label-one = "value-one"
  }
}

resource "google_network_connectivity_group" "primary"  {
 hub         = google_network_connectivity_hub.basic_hub.id
 name        = "default"
 auto_accept {
    auto_accept_projects = [
      "foo-${local.name_suffix}", 
      "bar-${local.name_suffix}", 
    ]
  }
}
