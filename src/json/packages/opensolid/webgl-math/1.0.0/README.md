# opensolid/webgl-math

This package supports interop between [`opensolid/geometry`](http://package.elm-lang.org/packages/opensolid/geometry/latest)
and [`Zinggi/elm-webgl-math`](http://package.elm-lang.org/packages/Zinggi/elm-webgl-math/latest).
You can:

  - Convert `opensolid/geometry` `Frame2d` and `Frame3d` values to the
    equivalent `elm-webgl-math` `Float3x3` and `Float4x4` transformation
    matrices
  - Transform `opensolid/geometry` `Point2d`, `Point3d`, `Vector2d` and
    `Vector3d` values using `elm-webgl-math` `Float3x3` and `Float4x4`
    transformation matrices

You shouldn't need this package for general use - you should be able to do most
geometric transformation you need (rotations, translations etc.) using OpenSolid
itself. However, this package may be useful for other transformations such as
shear or non-uniform scaling.

Note that the `Float2` and `Float3` types defined by `elm-webgl-math` are simply
type aliases for tuples of floats, e.g.

```elm
type alias Float3 =
    ( Float, Float, Float )
```

Therefore, conversion to and from OpenSolid point/vector/direction types is
trivial; for example, simply use the `Point3d` constructor to create a `Point3d`
value from a `Float3`, and use `Point3d.coordinates` to convert a `Point3d` back
to a `Float3`.

## Installation

```
elm package install opensolid/webgl-math
```

## Documentation

[Full API documentation](http://package.elm-lang.org/packages/opensolid/webgl-math/1.0.0)
is available.

## Usage details

The modules in this package are all designed to be imported using `as` to
'merge' them with the base OpenSolid modules; for example, using

```elm
import OpenSolid.Point3d as Point3d
import OpenSolid.WebGLMath.Point3d as Point3d
```

will let you use functions from both modules as if they were part of one big
`Point3d` module. For example, you could use the `transformBy` function from
this package's `Point3d` module with the `origin` value from the base `Point3d`
module as if they were part of the same module:

```elm
Point3d.transformBy transformationMatrix Point3d.origin
```

## Questions? Comments?

Please [open a new issue](https://github.com/opensolid/webgl-math/issues) if you
run into a bug, if any documentation is missing/incorrect/confusing, or if
there's a new feature that you would find useful. For general questions about
using this package, try posting on:

  - [Elm Slack](http://elmlang.herokuapp.com/) (mention @ianmackenzie in your
    questions so I get a notification)
  - [Stack Overflow](https://stackoverflow.com/questions/ask?tags=opensolid+elm)
    (tag your question with 'opensolid' and 'elm')
  - The [r/elm](https://reddit.com/r/elm) subreddit
  - The [elm-discuss](https://groups.google.com/forum/#!forum/elm-discuss)
    Google Group
  - Or if you happen to be in the New York area, come on out to the
    [Elm NYC meetup](https://www.meetup.com/Elm-NYC/) =)

Have fun, and don't be afraid to ask for help!
