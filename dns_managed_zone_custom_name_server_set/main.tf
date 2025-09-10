resource "google_dns_managed_zone" "custom-name-server-set-zone" {
  name        = "custom-name-server-set-zone"
  dns_name    = "example-${random_id.rnd.hex}.com."
  description = "Example DNS zone"
  labels = {
    foo = "bar"
  }
  name_server_set = "ns-cloud-d" 

}

resource "random_id" "rnd" {
  byte_length = 4
}
