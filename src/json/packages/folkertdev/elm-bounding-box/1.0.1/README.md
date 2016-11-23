# elm-bounding-box 

Calculations on 2D bounding boxes 


## Quick Start 

See [here](http://package.elm-lang.org/packages/folkertdev/elm-bounding-box/latest) for the full documentation.

```elm
import BoundingBox exposing (fromCorners, inside)
import Math.Vector2 exposing (vec2)

-- use fromCorners to create a bounding box
bbox = 
    fromCorners (vec2 0 0) (vec2 10 10) 

-- contains checks whether a point lies in a box
member = 
    inside (vec2 5 5) bbox
```

This library (currently) uses the `Math.Vector2.Vec2` type from [elm-community/elm-linear-algebra](http://package.elm-lang.org/packages/elm-community/elm-linear-algebra/latest) to
represent points in 2D space. The `Vec2` module in this package re-exports conversion functions from and to this type for your convenience.

