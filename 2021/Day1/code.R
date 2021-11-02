# https://www.envidat.ch/#/metadata/digitizing-historical-plague

library(rio)
library(tidyverse)
library(magrittr)

getwd()
pd <- rio::import("2021/Day1/Historical_plague_outbreaks.txt") %>%
  tibble()

pd <- pd %>%
  rename(latitude = Lon_WGS84,
         longitude = Lat_WGS84,
         year = Year_of_Outbreak,
         location = Location) %>%
  select(-c(X_Coord_ERTS89,
            Y_Coord_ERTS89))

eisleben <- pd[pd$location == "Eisleben",]
eisleben$year[1] <- 1398
eisleben$year[2] <- 1681
eisleben$longitude <- 11.550808
eisleben$latitude <- 51.524881

pd <- pd %>%
  filter(location != "Eisleben") %>%
  rbind(eisleben) %>%
  group_by(location, latitude, longitude) %>%
  mutate(id = cur_group_id()) %>%
  ungroup() %>%
  arrange(location, year) ; rm(eisleben)

