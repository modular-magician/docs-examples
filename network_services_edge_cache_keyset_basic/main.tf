
resource "google_network_services_edge_cache_keyset" "default" {
  name                 = "default-${local.name_suffix}"
  description          = "The default keyset"
  public_key {
    id = "my-public-key"
    value = "FHsTyFHNmvNpw4o7-rp-M1yqMyBF8vXSBRkZtkQ0RKY"
  }
  public_key {
    id = "my-public-key-2"
    value = "hzd03llxB1u5FOLKFkZ6_wCJqC7jtN0bg7xlBqS6WVM"
  }
}
