resource "google_agent_registry_skill_revision" "default" {
  location          = "global"
  skill             = "private-tf-test-skill"
  skill_revision_id = "ar-rev-${local.name_suffix}"

  archive_upload_source {
    archive_content = "UEsDBBQAAAAIAHgJZl1jo8AGRgAAAFMAAAAIABwAU0tJTEwubWRVVAkAA1Qp7WpTKe1qdXgLAAEESh8cAARUFgEA09XV5cpLzE21Usit1C1JLS7RLc7OzMnhSkktTi7KLCjJzM+zUlByVABJKYCllLh0gXqUFUJAIsFgxWBmcn5eSWpeiR4XAFBLAQIeAxQAAAAIAHgJZl1jo8AGRgAAAFMAAAAIABgAAAAAAAEAAAC0gQAAAABTS0lMTC5tZFVUBQADVCntanV4CwABBEofHAAEVBYBAFBLBQYAAAAAAQABAE4AAACIAAAAAAA="
  }
}
