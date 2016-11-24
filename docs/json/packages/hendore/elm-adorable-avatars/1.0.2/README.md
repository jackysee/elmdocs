elm-adorable-avatars
============

Simple, elegant and adorable avatars provided by
[http://avatars.adorable.io](http://avatars.adorable.io/).

![example avatar](https://api.adorable.io/avatars/128/elm-adorable-avatars.png)

Installing
----------

```sh
elm-package install hendore/elm-adorable-avatars
```

Basic Usage
-----------

```elm
module Main exposing (..)

import Html.Attributes
import AdorableAvatars


main =
    let
        size =
            128

        identifier =
            "elm-adorable-avatars"
    in
        AdorableAvatars.img [ Html.Attributes.style avatarStyle ] size identifier


avatarStyle =
    [ ( "borderRadius", "50%" ) ]
```

Maintainers
-----------

This package is maintained by

 - [Thomas Henley](https://github.com/hendore)

Thanks
------

This package would be useless without [Adorable Avatars](http://avatars.adorable.io/).

So thanks to all those behind that service for making `elm-adorable-avatars` possible.

License
-------

The source code for this package is released under the terms of the BSD3
license. See the `LICENSE` file.
