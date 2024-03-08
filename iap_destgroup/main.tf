resource "google_iap_tunnel_dest_group" "dest_group" {
  region = "us-central1"
  group_name = "testgroup%{random_suffix}"
  cidrs = [
    "10.1.0.0/16",
    "192.168.10.0/24",
  ]
}
