module Icons exposing (..)

import Svg exposing (svg, path)
import Svg.Attributes exposing (viewBox, d)
import Html exposing (Html)


caretRight : Html msg
caretRight =
    svg
        [ viewBox "0 0 1792 1792" ]
        [ path [ d "M1152 896q0 26-19 45l-448 448q-19 19-45 19t-45-19-19-45v-896q0-26 19-45t45-19 45 19l448 448q19 19 19 45z" ] [] ]


caretDown : Html msg
caretDown =
    svg
        [ viewBox "0 0 1792 1792" ]
        [ path [ d "M1408 704q0 26-19 45l-448 448q-19 19-45 19t-45-19l-448-448q-19-19-19-45t19-45 45-19h896q26 0 45 19t19 45" ] [] ]
