#### elm-aspect-ratio

A container for HTML that maintains its aspect ratio.

```elm
AspectRatio.view : Ratio.Rational -> Html a -> Html a
AspectRatio.img : Ratio.Rational -> String -> Html a
```

#### example

```elm
import Ratio
import AspectRatio
import Html exposing (Html, div)
import Html.Attributes exposing (style)

cinematic : Ratio.Rational
cinematic = Ratio.over 9 16

redRectangle =
    div [ style [ ( "background-color", "red" )
                , ( "width", "100%" )
                , ( "height", "100%" )
                ] ] []

cinematicImage : String -> Html a
cinematicImage src =
    AspectRatio.view cinematic redRectangle
```

