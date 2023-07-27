# networkmerge

A minimal example dataset was created with the ATIP tool. The example
dataset can be found in the `data` folder.

To read-in the data into Python we used the following:

``` python
import geopandas as gpd
network = gpd.read_file("data/minimal-example-2-scotthall-road.geojson")
# Column names:
network.columns

# colour is based on 'description' column
network.plot(column='description');
```

![](README_files/figure-commonmark/cell-2-output-1.png)
