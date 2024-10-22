data "google_project" "project" {
}

resource "google_tags_tag_key" "tag_key" {
  parent = "projects/${data.google_project.project.number}"
  short_name = "tag_key-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value" {
  parent = "tagKeys/${google_tags_tag_key.tag_key.name}"
  short_name = "tag_value-${local.name_suffix}"
}

resource "google_service_account" "test_account" {
  account_id   = "my-account-${local.name_suffix}"
  display_name = "Test Service Account"
}

resource "google_workflows_workflow" "example" {
  name          = "workflow-${local.name_suffix}"
  region        = "us-central1"
  description   = "Magic"
  service_account = google_service_account.test_account.id
  tags = {
    "${data.google_project.project.project_id}/${google_tags_tag_key.tag_key.short_name}" = "${google_tags_tag_value.tag_value.short_name}"
  }
  source_contents = <<-EOF
  # This is a sample workflow. You can replace it with your source code.
  #
  # This workflow does the following:
  # - reads current time and date information from an external API and stores
  #   the response in currentTime variable
  # - retrieves a list of Wikipedia articles related to the day of the week
  #   from currentTime
  # - returns the list of articles as an output of the workflow
  #
  # Note: In Terraform you need to escape the $$ or it will cause errors.

  - getCurrentTime:
      call: http.get
      args:
          url: $${sys.get_env("url")}
      result: currentTime
  - readWikipedia:
      call: http.get
      args:
          url: https://en.wikipedia.org/w/api.php
          query:
              action: opensearch
              search: $${currentTime.body.dayOfWeek}
      result: wikiResult
  - returnOutput:
      return: $${wikiResult.body[1]}
EOF
}
