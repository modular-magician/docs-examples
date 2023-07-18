resource "google_cloud_tasks_queue" "paused_queue" {
  name = "cloud-tasks-paused-queue-test-${local.name_suffix}"
  location = "us-central1"
  state = "PAUSED"
}
