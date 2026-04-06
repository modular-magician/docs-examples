resource "google_dialogflow_tool" "basic_tool" {
  location = "global"
  display_name = "dialogflow-tool-${local.name_suffix}"
  description = "A basic open_api_spec tool"
  tool_key = "dialogflow-tool-${local.name_suffix}"
  open_api_spec {
    text_schema = "openapi: 3.0.0\ninfo:\n  title: Example API\n  version: 1.0.0\npaths:\n  /example:\n    get:\n      summary: Example GET\n      responses:\n        '200':\n          description: OK"
  }
}
