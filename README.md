# Prerequisites

To run the code in this repo, you need to have a working Python
installation with the following packages installed (with pip in this
case):

``` {bash}
#| eval: false
pip install matplotlib pandas shapely geopandas osmnx networkx scipy folium mapclassify
```

# networkmerge

Example datasets were created with the ATIP tool and taken from the NPT
project. The example datasets can be found in the `data` folder.

<!-- To read-in the data into Python we used the following: -->

This repo contains different approaches to simplify and merge networks.

See [buffer-aggregate.md](buffer-aggregate.md) for a simple buffer and
aggregate approach.

For an in-progress paper describing different approaches, see
[paper.md](paper.md).
