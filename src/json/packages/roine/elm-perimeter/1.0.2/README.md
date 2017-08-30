ELM Perimeter
==

Creates an invisible perimeter around a target element and monitors mouse breaches.

Demo can be found [here](https://runelm.io/c/0oz).

Code sample:

```elm
module Main exposing (view, update, subscriptions)

import Html exposing (..)
import Perimeter exposing (Perimeter)


type alias Model =
    { perimeter : Perimeter }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { perimeter = Perimeter.init }


perimeterConfig =
    { padding = 12
    , onBreach = Breached
    , onLeave = Left
    , debug = True
    }


type Msg
    = Breached
    | Left
    | PerimeterMsg Perimeter.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Breached ->
            model ! []

        Left ->
            model  ! []

        PerimeterMsg subMsg ->
            let
                ( newPerimeterModel, maybeMsg ) =
                    Perimeter.update subMsg model.perimeter perimeterConfig
            in
                case maybeMsg of
                    Nothing ->
                        ( { model | perimeter = newPerimeterModel }, Cmd.none )

                    Just msg ->
                        update msg { model | perimeter = newPerimeterModel }


view : Model -> Html Msg
view model =
    Html.map PerimeterMsg (Perimeter.view perimeterConfig model.perimeter [ button [] [ text model.buttonText ] ])


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map PerimeterMsg (Perimeter.subscriptions model.perimeter)


main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
```
