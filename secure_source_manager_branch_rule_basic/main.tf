resource "google_secure_source_manager_instance" "instance" {
    location = "us-central1"
    instance_id = "my-instance-${local.name_suffix}"
}

resource "google_secure_source_manager_repository" "repository" {
    location = "us-central1"
    repository_id = "my-repository-${local.name_suffix}"
    instance = google_secure_source_manager_instance.instance.name
}

resource "google_secure_source_manager_branch_rule" "default" {
    # Ensure this resource depends on both the instance and repository
    depends_on = [
        google_secure_source_manager_instance.instance,
        google_secure_source_manager_repository.repository
    ]
    branch_rule_id = "my-branchrule-${local.name_suffix}"
}
