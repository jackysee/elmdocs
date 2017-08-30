# elm-multi-email-input [![Build Status](https://travis-ci.org/elm-lang/core.svg?branch=master)](https://travis-ci.org/larribas/elm-multi-email-input)

Input multiple emails on elm


## [Try it out](https://larribas.github.io/elm-multi-email-input/)

![alt text](https://github.com/larribas/elm-multi-email-input/raw/master/demo/preview.gif "Animated preview for the component")

## How to use it

Here's an example of a minimal integration scenario:

```elm
module Main exposing (main)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Ev
import MultiEmailInput


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { emails : List String
    , inputState : MultiEmailInput.State
    }


type Msg
    = MultiEmailInputMsg MultiEmailInput.Msg


init : ( Model, Cmd Msg )
init =
    ( { emails = []
      , inputState = MultiEmailInput.init "multi-email-textarea"
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MultiEmailInputMsg subMsg ->
            let
                ( nextState, nextEmails, nextCmd ) =
                    MultiEmailInput.update subMsg model.inputState model.emails
            in
            ( { model | emails = nextEmails, inputState = nextState }, Cmd.map MultiEmailInputMsg nextCmd )


view : Model -> Html Msg
view model =
    MultiEmailInput.view
        MultiEmailInputMsg
        []
        "Write an email here"
        model.emails
        model.inputState

```


## Contribute

Any contributions or feedback are welcome!
