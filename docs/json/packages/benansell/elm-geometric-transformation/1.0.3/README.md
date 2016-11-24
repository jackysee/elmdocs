# elm-geometric-transformation [![Build status](https://ci.appveyor.com/api/projects/status/1fspr6u4h801x569/branch/master?svg=true)](https://ci.appveyor.com/project/benansell/elm-geometric-transformation/branch/master) [![Build Status](https://travis-ci.org/benansell/elm-geometric-transformation.svg?branch=master)](https://travis-ci.org/benansell/elm-geometric-transformation)

An elm package for performing geometric transformations on points

The following 2D transformations are supported:
* Identity
* Rotate
* Scale
* Shear
* Translate

API documentation can be found on [elm-packages](http://package.elm-lang.org/packages/benansell/elm-geometric-transformation/latest)

## Quick Start
To rotate a any shape (list of points) by an angle around the origin:

```elm
    rotateShape : Float -> List Point -> List Point
    rotateShape angle points =
        let
            transform =
                rotate Clockwise angle
                    |> apply
        in
            List.map transform points
```

More complicated transforms can be created by using combine as demonstrated in the working example.


## Working Example
This package was used to animate the Elm logo as part of the [elm-webpack-seed](https://github.com/benansell/elm-webpack-seed)


## Not the droid you are looking for?
The following elm packages have similar functionality:
* [elm-graphics](http://package.elm-lang.org/packages/evancz/elm-graphics/latest)
* [elm-linear-algebra](http://package.elm-lang.org/packages/elm-community/elm-linear-algebra/latest)
