# collisions

This is a library for collision detection in 2D and 3D. The library only detects collisions between convex hulls and points. Full detection between two hulls is not yet supported.

[Here](https://nphollon.github.io/collisions.html) is an example of the 2D collision detection in action. You can view the source code in the `examples` folder.

## Changes from 1.* to 2.0.0

We removed the dependency on `elm-linear-algebra`. `Collision2D` and `Collision3D` now have their own type constructors for vectors.