data "google_project" "project" {

}

resource "google_dataplex_lake" "example" {
  name         = "tf-test-lake%{random_suffix}"
  location     = "us-central1"
  project = "PROJECT_NAME"
}


resource "google_dataplex_task" "example" {

    task_id      = "tf-test-task%{random_suffix}"
    location     = "us-central1"
    lake         = google_dataplex_lake.example.name
    
    description = "Test Task Basic"
    
    display_name = "task-basic"

    labels = { "count": "3" }

    trigger_spec  {
        type = "RECURRING"
        disabled = false
        max_retries = 3
        start_time = "2023-10-02T15:01:23Z"
        schedule = "1 * * * *"
    }
    
    execution_spec {
        service_account = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
        project = "PROJECT_NAME"
        max_job_execution_lifetime = "100s"
        kms_key = "234jn2kjn42k3n423"
    }
    
    spark {
        python_script_file = "gs://dataproc-examples/pyspark/hello-world/hello-world.py"

    }
    
    project = "PROJECT_NAME"
    
}
