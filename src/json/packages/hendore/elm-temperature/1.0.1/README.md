elm-temperature
============

Library for converting between celsius, fahrenheit and kelvin temperature
scales.

[Docs](http://package.elm-lang.org/packages/hendore/elm-temperature/latest)

Installing
----------

```sh
elm-package install hendore/elm-temperature
```

Basic Usage
-----------

```elm
module Main exposing (..)

import Temperature.Convert
import Html


main =
    Temperature.Convert.celsiusToFahrenheit 20
        |> toString
        |> Html.text
```

Maintainers
-----------

This package is maintained by

 - [Thomas Henley](https://github.com/hendore)

License
-------

The source code for this package is released under the terms of the BSD3
license. See the `LICENSE` file.
