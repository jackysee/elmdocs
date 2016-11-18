module App exposing (..)

import Html exposing (Html, text, div)
import Json.Decode

type alias Model =
    { message : String
    }


init : Maybe (Json.Decode.Value )-> ( Model, Cmd Msg )
init str =
    ( { message = "Hello" }, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [] [ text model.message ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
