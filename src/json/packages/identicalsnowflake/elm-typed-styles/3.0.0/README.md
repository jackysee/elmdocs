# Typed Styles for Elm

Adds typed styles on top of elm-html. Example usage:

```haskell
import Html exposing (..)
import Html.Attributes exposing (style,attribute)
import Color exposing (..)

import TypedStyles exposing (..)


main =
  div [ style [
      backgroundColor blue
    , padding 20 px
    , textCenter
    , color white
    , fontSize 50 px
    , border 5 px solid orange
    , top 50 px
    , left 50 px
    , width 200 px
    , height 400 px
    , ("overflow-x","hidden")
    , ("overflow-y","scroll")
  ]] [ text "hi" ]
```

Underscored variants of most functions are provided for use with my style effects
library.
