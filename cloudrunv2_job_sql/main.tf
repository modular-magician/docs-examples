resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  launch_stage = "BETA"
  
  template {
    template{
      volumes {
        name = "cloudsql"
        cloud_sql_instance {
          instances = [google_sql_database_instance.instance.connection_name]
        }
      }

      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        env {
          name = "FOO"
          value = "bar"
        }
        env {
          name = "latestdclsecret"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret.secret.secret_id
              version = "1"
            }
          }
        }
        volume_mounts {
          name = "cloudsql"
          mount_path = "/cloudsql"
        }
      }
    }
  }
}

data "google_project" "project" {
}

resource "google_secret_manager_secret" "secret" {
  secret_id = "secret-${local.name_suffix}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  secret = google_secret_manager_secret.secret.name
  secret_data = "secret-data"
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.secret]
}

resource "google_sql_database_instance" "instance" {
  name             = "cloudrun-sql-${local.name_suffix}"
  region           = "us-central1"
  database_version = "MYSQL_5_7"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = "false"
}
