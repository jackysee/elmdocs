module Main exposing (..)

import App exposing (..)
import Html
import Models exposing (Model, StoreModel)
import Msgs exposing (Msg)


main : Program (Maybe StoreModel) Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
