
# Prerequisites

..

``` r
library(tidyverse)
```

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.2     ✔ readr     2.1.4
    ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
    ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ✔ purrr     1.0.1     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(sf)
```

    Linking to GEOS 3.11.2, GDAL 3.6.2, PROJ 9.2.0; sf_use_s2() is TRUE

``` r
library(tmap)
```

    The legacy packages maptools, rgdal, and rgeos, underpinning the sp package,
    which was just loaded, will retire in October 2023.
    Please refer to R-spatial evolution reports for details, especially
    https://r-spatial.org/r/2023/05/15/evolution4.html.
    It may be desirable to make the sf package available;
    package maintainers should consider adding sf to Suggests:.
    The sp package is now running under evolution status 2
         (status 2 uses the sf package in place of rgdal)

``` r
input_complex = sf::read_sf("data/rnet_princes_street.geojson")
# input_simple = sf::read_sf("data/Edc_Roadlink.geojson")
# input_complex_union = sf::st_union(input_complex)
# input_complex_30m_buffer = sf::st_buffer(input_complex_union, 30)
# input_complex_convex_hull = sf::st_convex_hull(input_complex_union)
# input_simple = sf::st_intersection(input_simple, input_complex_convex_hull)
# sf::write_sf(input_simple, "data/rnet_pinces_street_simple.geojson")
# names(input_complex)[1] = "value"
# sf::write_sf(input_complex, "data/rnet_princes_street.geojson", delete_dsn = TRUE)
input_simple = sf::read_sf("data/rnet_pinces_street_simple.geojson")
```

``` r
m1 = qtm(input_complex)
m2 = qtm(input_simple)
tmap_arrange(m1, m2, nrow = 1)
```

![](merge_files/figure-commonmark/plotting%20spatial%20data%20using%20the%20tmap-1.png)

``` r
remotes::install_github("ropensci/stplanr")
```

    Skipping install of 'stplanr' from a github remote, the SHA1 (bdbdd983) has not changed since last install.
      Use `force = TRUE` to force installation

``` r
# stplanr::rnet_join
```

The values in the `input_complex` dataset are as follows:

``` r
names(input_complex)
```

    [1] "value"     "Quietness" "length"    "index"     "geometry" 

``` r
summary(input_complex$value)
```

       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
        0.0     3.0    88.0   328.4   375.2  3212.0 

To join the network values we will try the `rnet_join` function in
`stplanr`, which has the following arguments:

``` r
args(stplanr::rnet_join)
```

    function (rnet_x, rnet_y, dist = 5, length_y = TRUE, key_column = 1, 
        subset_x = TRUE, dist_subset = 5, split_y = TRUE, ...) 
    NULL

``` r
input_simple_id = input_simple |>
  select(identifier)

rnet_joined = stplanr::rnet_join(input_simple_id, input_complex, dist = 30)
```

    Warning: attribute variables are assumed to be spatially constant throughout
    all geometries

    Warning in st_cast.sf(sf::st_cast(x, "MULTILINESTRING"), "LINESTRING"):
    repeating attributes for all sub-geometries for which they may not be constant

    Warning: attribute variables are assumed to be spatially constant throughout
    all geometries

    Warning in st_cast.sf(sf::st_cast(x, "MULTILINESTRING"), "LINESTRING"):
    repeating attributes for all sub-geometries for which they may not be constant

``` r
# sf::write_sf(rnet_joined, "data/rnet_joined.geojson", delete_dsn = TRUE)
buffered_input_simple_id <- st_buffer(input_simple_id, dist = 30)

identified_line_index <- unique(rnet_joined$index)
length_of_identified_line_index <- length(identified_line_index)
print(length_of_identified_line_index)
```

    [1] 1018

``` r
all_line_index <- unique(input_complex$index)
length_of_all_line_index <- length(all_line_index)
print(length_of_all_line_index)
```

    [1] 1144

``` r
# Finding the missing line indices
missing_line_index <- setdiff(all_line_index, identified_line_index)

# Filtering the missing lines from the input_complex dataset
missing_lines <- input_complex[input_complex$index %in% missing_line_index, ]

# Plotting the missing lines (in red) and the rest of the input_complex dataset (in blue)
tm_shape(input_complex) + tm_lines(col="blue") +
  tm_shape(missing_lines) + tm_lines(col="red", lwd=2) +
  tm_shape(buffered_input_simple_id) + tm_borders(col="green", lwd=2)
```

![](merge_files/figure-commonmark/unnamed-chunk-7-1.png)

The overlapping network values are as follows:

``` r
tm_shape(rnet_joined) + tm_fill("value")
```

![](merge_files/figure-commonmark/overlapping-1.png)

We can calculate the distance-weighted average of the network values as
follows:

``` r
summary(rnet_joined$length_y)
```

         Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
      0.00819   5.71282  11.58242  20.87195  23.08895 254.92652        26 

``` r
summary(rnet_joined$length)
```

        Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
      0.6247   9.5251  17.4445  32.5600  38.5052 559.2821       26 

``` r
rnet_joined_df = rnet_joined |>
  sf::st_drop_geometry() |>
  mutate(value_weighted = value * length_y)
total_d = sum(input_complex$length * input_complex$value, na.rm = TRUE)
total_d
```

    [1] 17164314

``` r
total_j = sum(rnet_joined_df$value_weighted, na.rm = TRUE)
total_j
```

    [1] 40470554

``` r
difference = total_d / total_j
round(1 - total_d / total_j, 3) # New net has 15% more value
```

    [1] 0.576

``` r
rnet_joined_df$value_weighted = rnet_joined_df$value_weighted * difference
# sum(rnet_joined_df$value_weighted, na.rm = 
# TRUE) / sum(rnet_joined_df$length_y, na.rm = TRUE)
# sum(input_complex$value * input_complex$length) / sum(input_complex$length)
rnet_joined_aggregated = rnet_joined_df |>
  group_by(identifier) |>
  summarise(value = sum(value_weighted, na.rm = TRUE) / sum(length_y, na.rm = TRUE))
sum(rnet_joined_aggregated$value, na.rm = TRUE) == sum(input_complex$value, na.rm = TRUE)
```

    [1] FALSE

``` r
rnet_joined_linestrings = left_join(input_simple, rnet_joined_aggregated, by = "identifier")
```

The result is as follows:

``` r
rnet_joined_linestrings$length_simple = as.numeric(sf::st_length(rnet_joined_linestrings))
cor(rnet_joined_linestrings$length_simple, rnet_joined_linestrings$length)
```

    [1] 0.8687748

``` r
sum(rnet_joined_linestrings$value * rnet_joined_linestrings$length, na.rm = TRUE)
```

    [1] 9762652

``` r
sum(input_complex$value * input_complex$length, na.rm = TRUE)
```

    [1] 17164314

``` r
tm_shape(rnet_joined_linestrings) + tm_lines(col="value", palette="Blues", lwd=2)
```

![](merge_files/figure-commonmark/joined-1.png)
