## ⚠️ EXPERIMENTAL! ⚠️

This library is in its earliest stages and has not yet been battle-tested.
It needs more documentation, examples, and performance optimization.

# hashed-class

Instead of writing (and namespacing) [`elm-css`](package.elm-lang.org/packages/rtfeldman/elm-css/latest)
classnames by hand, automatically generate them based on their contents.

### Example

```elm
import Css exposing (backgroundColor, rgb)
import Css.Class as Hashed
import Html exposing (Attribute, Html, text, button)
import Html.Attributes exposing (class)

warningClass : Class
warningClass =
    -- Notice how we don't specify a classname here. The classname will be
    -- generated for us based on a hash of the (backgroundColor (rgb 128 12 12))
    -- style we specified here.
    Hashed.class [ backgroundColor (rgb 128 12 12) ]


warning : Attribute msg
warning =
    -- This is the equivalent of writing out `class "fc93bca7"` by hand.
    -- (The actual hash that gets generated here may be different. Of course,
    -- the whole point is that you don't care what it is!)
    --
    -- Remember, this just generates the attribute. You still need to use
    -- `warningClass` elsewhere - either passing it to the `elm-css` CLI to
    -- generate a .css file or using it with `Hashed.toStyleNode` to generate
    -- a <style> element. Otherwise you won't see any styles show up!
    Hashed.toAttribute warningClass


deleteButton : Html msg
deleteButton =
    button [ warning ] [ text "Confirm Deletion" ]
```

You can also use `Hashed.with` to create functions that look like normal `Html`
element creation functions (such as `button`, `div`, etc) except with styles
pre-applied to them.

```elm

import Css exposing (backgroundColor, rgb)
import Css.Class as Hashed
import Html exposing (Attribute, Html, button, text)
import Html.Attributes exposing (class)

warning : Class
warning =
    -- Let's assume this automatically generates a classname of "fc4bde3a1"
    Hashed.class [ backgroundColor (rgb 128 12 12) ]

{-| Create a `button` variant that automatically includes the warning style.
-}
warningButton : List (Attribute msg) -> List (Html msg) -> Html msg
warningButton =
    Hashed.with warning button

confirmDeleteButton : Html msg
confirmDeleteButton =
    -- Equivalent to:
    --
    -- button [ class "fc4bde3a1" ][ text "Confirm Deletion" ]
    warningButton [] [ text "Confirm Deletion" ]
```
