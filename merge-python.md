
In Python these inputs are as follows:

``` python
import geopandas as gpd
input_simple = gpd.read_file("data/rnet_pinces_street_simple.geojson")
input_complex = gpd.read_file("data/rnet_princes_street.geojson")
```

Plot them as follows:

``` python
input_complex.plot()
```

    <AxesSubplot:>

<img
src="merge-python_files/figure-commonmark/inputs_complex_python-output-2.png"
id="inputs_complex_python-2" />

``` python
input_simple.plot()
```

    <AxesSubplot:>

<img
src="merge-python_files/figure-commonmark/inputs_simple_python-output-2.png"
id="inputs_simple_python-2" />
