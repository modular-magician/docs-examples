resource "google_sql_source_representation_instance" "instance" {
  name               = "my-instance-${local.name_suffix}"
  region             = "us-central1"
  database_version   = "MYSQL_8_0"
  host               = "10.20.30.40"
  port               = 3306
  username           = "someuser"
  password           = "password"
  ca_certificate     = file("path/to/server-ca.pem")
  client_certificate = file("path/to/client-cert.pem")
  client_key         = file("path/to/client-key.pem")
  dump_file_path     = "gs://path/to/mysqldump"
}
