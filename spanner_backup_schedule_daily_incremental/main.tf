resource "google_spanner_instance" "main" {
  name         = "instance-id-${local.name_suffix}"
  config       = "regional-europe-west1"
  display_name = "main-instance"
  num_nodes    = 1
  edition      = "ENTERPRISE"
}

resource "google_spanner_database" "database" {
  instance = google_spanner_instance.main.name
  name     = "database-id-${local.name_suffix}"
  version_retention_period = "3d"
  ddl = [
    "CREATE TABLE t1 (t1 INT64 NOT NULL,) PRIMARY KEY(t1)",
    "CREATE TABLE t2 (t2 INT64 NOT NULL,) PRIMARY KEY(t2)",
  ]
  deletion_protection = false
}

resource "google_spanner_backup_schedule" "incremental-backup" {
  instance = google_spanner_instance.main.name

  database = google_spanner_database.database.name

  name = "backup-schedule-id-${local.name_suffix}"
  
  retention_duration = "31620000s" // 366 days (maximum possible retention)

  spec {
    cron_spec {
      //   0 2/12 * * * : every 12 hours at (2, 14) hours past midnight in UTC.
      //   0 2,14 * * * : every 12 hours at (2,14) hours past midnight in UTC.
      //   0 2 * * *    : once a day at 2 past midnight in UTC.
      //   0 2 * * 0    : once a week every Sunday at 2 past midnight in UTC.
      //   0 2 8 * *    : once a month on 8th day at 2 past midnight in UTC.
      text = "0 12 * * *"
    }
  }
  // The schedule creates incremental backup chains.
  incremental_backup_spec {}
}
