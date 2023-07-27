
# networkmerge

A minimal example dataset was created with the ATIP tool. The example
dataset can be found in the `data` folder.

To read-in the data into Python we used the following:

``` python
import geopandas as gpd
network = gpd.read_file("data/minimal-input.geojson")
# Column names:
network.columns
```

    Index(['value', 'geometry'], dtype='object')

``` python
# colour is based on 'description' column
network.plot(column='value')
```

![](README_files/figure-commonmark/unnamed-chunk-1-1.png)
