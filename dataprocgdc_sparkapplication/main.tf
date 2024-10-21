resource "google_dataproc_gdc_application_environment" "app_env" {
  application_environment_id = "tf-e2e-spark-app-env-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  location        = "us-west2"
  namespace = "default"
}

resource "google_dataproc_gdc_spark_application" "spark-application" {
  spark_application_id = "tf-e2e-spark-app-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  location        = "us-west2"
  namespace = "default"
  labels = {
    "test-label": "label-value"
  }
  annotations = {
    "an_annotation": "annotation_value"
  }
  properties = {
    "spark.executor.instances": "2"
  }
  application_environment = google_dataproc_gdc_application_environment.app_env.name
  version = "1.2"
  spark_application_config {
    main_class = "org.apache.spark.examples.SparkPi"
    jar_file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
    args = ["10"]
  }
}
