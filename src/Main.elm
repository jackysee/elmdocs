module Main exposing (..)

import App exposing (..)
import Html
import Json.Decode


main : Program (Maybe Json.Decode.Value) Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
