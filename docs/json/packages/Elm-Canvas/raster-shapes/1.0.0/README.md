# Raster Shapes for Elm

Shapes dont lend themselves well to being rendered on a raster screen. A screen is a grid of pixels, and a curve cant be perfectly represented in a grid of pixels. These functions take the parameters of a shape and return which pixels should be lit up to render that shape.


```
A line from (0,0) to (9,7), rendered discretely.

  0         9
0 --------------
  | #
  |  ##
  |    #
  |     #
  |      ##
  |        #
7 |         #
  |
  |

```


RasterShapes is agnostic about how you are rendering. The line function for example, just takes the start and end positions and returns a list of positions. What you do with those positions is up to you.

These functions are implementations of the Bresenham algorithms, mainly the Bresenham line algorithm.