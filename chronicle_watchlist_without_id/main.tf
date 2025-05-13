resource "google_chronicle_watchlist" "example" {
  location = "us"
  instance = "CHRONICLE_ID"
  description = "watchlist-description-${local.name_suffix}"
  display_name = "watchlist-name-${local.name_suffix}"
  multiplying_factor = 1
  entity_population_mechanism {
    manual {

    }
  }
  watchlist_user_preferences {
    pinned = true
  }
}
