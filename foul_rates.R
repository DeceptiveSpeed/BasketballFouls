###### CALCULATE INDIVIDUAL FOUL RATES

library(tidyverse)
library(gamezoneR)

# Load in the data
future::plan("multisession")
tictoc::tic()
progressr::with_progress({
  pbp <- gamezoneR::load_gamezone_pbp(gamezoneR:::available_seasons())
})
tictoc::toc()

test <- pbp %>%
  filter(season == "2021-22")

# Just for now we'll use ISU's data so we can save some time on the calculations we'll be doing
test <- test %>%
  filter(home == "Iowa State" | away == "Iowa State")

pbp_line <- test %>%
  filter(!is.na(home_1)) %>%
  pivot_longer(cols = c(away_1, away_2, away_3, away_4, away_5, home_1, home_2, home_3, home_4, home_5),
               values_to = "player_name",
               names_to = "player_lineup")

# Add some more information that will be used later
pbp_line <- pbp_line %>%
  mutate(possession = ifelse(home == event_team, "home", "away"),
         player_lineup = substr(player_lineup, 0, 4),
         side = ifelse(player_lineup == possession, "offense", "defense"),
         def_team = ifelse(home == event_team, away, home),
         player_team = ifelse(player_lineup == "home", home, away),
         poss_id = paste0(game_id, poss_number))

pbp_line <- pbp_line %>%
  filter(substitution == 0, !str_detect(desc, "Start of "))

# TODO - erase this
fouls <- pbp_line %>%
  filter(str_detect(desc, "foul"))


str_extract("Personal foul committed by Gabe Kalscheur.", "committed by(.*)")

