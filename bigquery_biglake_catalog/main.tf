resource "google_biglake_catalog" "default"  {
    name = "my_catalog-${local.name_suffix}"
    # Hard code to avoid invalid random id suffix
    location = "US"
}
