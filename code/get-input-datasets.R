# Aim: get input datasets for the paper

library(sf)
rnet_wyca = pct::get_pct_rnet("west-yorkshire")
# library(mapedit)

# Visual inspection of OSM at 
# https://www.openstreetmap.org/node/10438140#map=17/53.83244/-1.58852&layers=Y
# And
# https://www.openstreetmap.org/node/313102482#map=19/53.79826/-1.58538&layers=Y

otley_road_point = c(-1.5910, 53.8325)
armley_road_point = c(-1.5852, 53.7985)
otley_road_point_sf = st_point(otley_road_point) |>
  st_sfc(crs = 4326)
armley_road_point_sf = st_point(armley_road_point) |>
  st_sfc(crs = 4326)
otley_road_buffer = st_buffer(otley_road_point_sf, 250)
armley_road_buffer = st_buffer(armley_road_point_sf, 250)
rnet_otley = rnet_wyca |>
  st_intersection(otley_road_buffer) |>
  st_cast("LINESTRING")
rnet_armley = rnet_wyca |>
  st_intersection(armley_road_buffer) |>
  st_cast("LINESTRING")

# keep only connected components
# new function for stplanr?
filter_connected = function(x, n_groups = 1){
  g = stplanr::rnet_group(x, d = 1)
  g_ordered = sort(table(g), decreasing = TRUE)
  g_keep = names(g_ordered)[1:n_groups]
  x = x[g %in% g_keep, ]
  x
}
rnet_otley = filter_connected(rnet_otley)
rnet_armley = filter_connected(rnet_armley)

mapview::mapview(rnet_otley)
mapview::mapview(rnet_armley)

write_sf(rnet_otley, "data/rnet_otley.geojson")
write_sf(rnet_armley, "data/rnet_armley.geojson")

# Scott Hall Road


network = sf::read_sf("https://raw.githubusercontent.com/nptscot/networkmerge/e6f25a7214c15c9c2d5e2cb99a5e4bd4dd92c1b5/data/minimal-example-2-scotthall-road.geojson")
network$description = as.numeric(network$description)
network = network["description"]
network$value = c(1, 2)
network = stplanr::overline(network, attrib = "value")
network
sf::write_sf(network, "data/minimal-input.geojson")
plot(network[1, "value"])
plot(network[2, "value"])
network_merged = network
network_merged$value[2] = network_merged$value[1] + network_merged$value[2]
network_merged = network_merged[-1, ]
plot(network_merged)
sf::write_sf(network_merged, "data/minimal-output.geojson")