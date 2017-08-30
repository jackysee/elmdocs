# Elm Polylinear Scale

Create a polylinear scales and map values.

As explained here <https://github.com/d3/d3-scale/blob/master/README.md#continuous_domain>

```elm
scale = polylinearScale [(0, 0), (100, 50), (300, 100)]

scale 100 == 50
scale 150 == 62.5
```

