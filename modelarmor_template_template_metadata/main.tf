# Copyright 2024 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is a Terraform template file (.tf.tmpl) for creating a Template resource.

resource "google_model_armor_template" "template-template-metadata" {
  location    = "<no value>"
  template_id = "<no value>"

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "<no value>"
        confidence_level = "<no value>"
      }
    }
  }
  template_metadata {
    custom_llm_response_safety_error_message = "<no value>"
    log_sanitize_operations                  = <no value>
    log_template_operations                  = <no value>
    multi_language_detection {
      enable_multi_language_detection        = <no value>
    }
    ignore_partial_invocation_failures       = <no value>
    custom_prompt_safety_error_code          = <no value>
    custom_prompt_safety_error_message       = "<no value>"
    custom_llm_response_safety_error_code    = <no value>
    enforcement_type                         = "<no value>"
  }
}
