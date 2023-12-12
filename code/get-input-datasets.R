# Aim: get input datasets for the paper

library(tmap)
tmap_mode("view")
rnet_wyca = pct::get_pct_rnet("west-yorkshire")
# library(mapedit)

# Visual inspection of OSM at 
# https://www.openstreetmap.org/node/10438140#map=17/53.83244/-1.58852&layers=Y
# And
# https://www.openstreetmap.org/node/313102482#map=19/53.79826/-1.58538&layers=Y

otley_road_point = c(53.8325274, -1.5910451) |> rev()
armley_road_point = c(53.7985648, -1.5852985) |> rev()
otley_road_point_sf = sf::st_point(otley_road_point) |> sf::st_sfc(crs = 4326)
armley_road_point_sf = sf::st_point(armley_road_point) |> sf::st_sfc(crs = 4326)
otley_road_buffer = sf::st_buffer(otley_road_point_sf, 250)
armley_road_buffer = sf::st_buffer(armley_road_point_sf, 250)
rnet_otley = rnet_wyca |>
  sf::st_intersection(otley_road_buffer) |>
  dplyr::filter(bicycle > 0)
rnet_armley = rnet_wyca |> sf::st_intersection(armley_road_buffer) |> 
  dplyr::filter(bicycle > 0)


mapview::mapview(rnet_otley)
mapview::mapview(rnet_armley)
