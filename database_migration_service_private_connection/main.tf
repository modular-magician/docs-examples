resource "google_database_migration_service_private_connection" "default" {
	display_name          = "dbms_pc"
	location              = "us-central1"
	private_connection_id = "my-connection-${local.name_suffix}"

	labels = {
		key = "value"
	}

	vpc_peering_config {
		vpc_name = data.google_compute_network.private_connection.id
		subnet = "10.128.0.0/9"
	}

	depends_on = [google_compute_network.private_connection]
}

resource "google_compute_network" "private_connection" {
  name = "my-private-connection-network-${local.name_suffix}"
  auto_create_subnetworks = true
}
