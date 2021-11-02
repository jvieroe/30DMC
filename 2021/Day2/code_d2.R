rm(list = ls())

library(rio)
library(tidyverse)
library(magrittr)
library(sf)
library(patchwork)
library(knitr)


getwd()
roads <- st_read(dsn = "2021/Day2/data/dataverse_files",
                 layer = "roman_roads_v2008")

roads <- roads %>%
  st_transform(crs = 4326)

map <- st_read(dsn = "2021/Day2/data/ne_10m_admin_0_countries/ne_10m_admin_0_countries",
               layer = "ne_10m_admin_0_countries") %>%
  st_transform(crs = 4326) %>%
  select(c(SOVEREIGNT, geometry))

# map <- map %>%
#   st_crop(roads)

map_union <- map %>%
  st_union()

ggplot() +
  geom_sf(data = map,
          color = "grey70",
          #fill = scales::alpha("#E8E1D5", .5),
          fill = "cornsilk1",
          size = .15) +
  geom_sf(data = map_union,
          color = "black",
          fill = NA,
          size = .25) +
  geom_sf(data = roads, aes(size = CLASS,
                            color = CLASS)) +
  #scale_size_continuous(range = c(.1, .95)) +
  scale_size_manual(values = c(.65, .35)) +
  scale_color_manual(values = c("firebrick4",
                                "forestgreen")) +
  coord_sf(xlim = c(st_bbox(roads)[[1]], st_bbox(roads)[[3]]),
           ylim = c(st_bbox(roads)[[2]], st_bbox(roads)[[4]])) +
  theme_void() +
  theme(legend.position = "none",
        #plot.background = element_rect(fill = scales::alpha("#E8E1D5", .25))
        plot.background = element_rect(fill = "ivory")
        )

ggsave(plot = last_plot(),
       filename = "2021/Day2/roads_plot.png")
knitr::plot_crop("2021/Day2/roads_plot.png",
                 quiet = T)


# 9, 17,
# 39, 45

