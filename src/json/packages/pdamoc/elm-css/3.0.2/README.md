# elm-css
Functions to help you write CSS in Elm


## This is ALPHA quality right now. 

The API is unstable and likely to change dramatically! Use at your own risk.  


# Example 

```elm
module Main exposing (..)

import Html as H exposing (Html)
import Html.Attributes exposing (href, style)
import Css exposing (..)
import Color exposing (red, white, lightRed)


type Classes
    = Main


( id, class, classes ) =
    namespace "demo"
rules : List Rule
rules =
    [ (.) Main
        [ background (color' red)
        , width (vw 100)
        , height (vh 100)
        , displayFlex
        , flexDirection column
        , alignItems center
        , justifyContent center
        ]
    , descendant [ (.) Main, a ]
        [ color (color' white)
        , textDecoration none
        , fontSize (px 32)
        ]
    , (!:) a hover [ textDecoration underline ]
    ]


main : Html a
main =
    styledNode []
        (withNamespace "demo" rules)
        [ H.div [ class Main ]
            [ H.a [ href "#" ]
                [ H.text "A BIG Centered Link" ]
            , H.div
                -- inline style usage
                [ style
                    [ width (pct 80)
                    , height (px 100)
                    , backgroundColor (color' lightRed)
                    , marginAll (px 40)
                    ]
                ]
                []
            ]
        ]
```