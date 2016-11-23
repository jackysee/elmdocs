# elm-cursor

Alternative way to build elm apps. This module contains all low level primitives
to build elm apps with high level cursor abstraction.

Minimal cursor-powered application looks like this:

```elm
module Minimal where

import Graphics.Element exposing (show)

import Cursor

main =
  Cursor.start model view

model =
  "Hello World!"

view =
  show << Cursor.get
```

More examples can be found in ``examples/`` folder.
