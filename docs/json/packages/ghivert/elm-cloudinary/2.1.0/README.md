# Elm Cloudinary [![Travis Build Status](https://travis-ci.org/ghivert/elm-cloudinary.svg?branch=master)](https://travis-ci.org/ghivert/elm-cloudinary)

This library provides a user friendly interface to upload your photos to Cloudinary.
The library is far from complete today, so do not hesitate to post an issue explaining what you want to do, or propose a PR.

## Examples

The usage example remains in two distinct files : an Elm file, and a JavaScript file, for file reading (at the moment, Elm does not handle the FileReader JavaScript module).

**Main.elm**
```elm
module Main exposing (..)

import Html
import Http
import Cloudinary
import Html exposing (Html)
import Html.Events as Events
import Html.Attributes as Attributes
import Json.Decode as Decode

type alias Model =
  { photoId : Maybe String
  , uploadError : Maybe String
  }

type Msg
  = ImageSelected String
  | ImageRead String
  | ImageUploaded (Result Http.Error String)

type alias CloudinarySettings =
  { username : String
  , apiKey : String
  , timestamp : Int
  , signature : String
  }

port imageSelected : String -> Cmd msg
port imageRead : (String -> msg) -> Sub msg

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

defaultModel : Model
defaultModel =
  { photoId = Nothing
  , uploadError = Nothing
  }

init : ( Model, Cmd Msg )
init =
  ( defaultModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ImageSelected id ->
      ( model, imageSelected id )

    ImageRead photo ->
      ( model
      , Cloudinary.uploadPhoto
        { username = "sample"
        , apiKey = "apiKeySample"
        , timestamp = 1488376411
        , signature = "signatureSample"
        } ImageUploaded photo
      )

    ImageUploaded photoId ->
      case photoId of
        Err error ->
          ( { model | uploadError = Just <| toString <| error }, Cmd.none )

        Ok id ->
          ( { model | photoId = Just id }, Cmd.none )

view : Model -> Html Msg
view model =
  Html.div []
    [ Html.div
      [ Attributes.style [ ( "text-align", "center" ), ( "padding", "100px" ) ] ]
      [ case model.photoId of
        Nothing ->
          Html.form []
            [ Html.input
              [ Attributes.name "file"
              , Attributes.type_ "file"
              , Attributes.id "cloudinary-uploader"
              , Events.on "change"
                <| Decode.succeed
                <| ImageUpload
                <| ImageSelected "cloudinary-uploader"
              ]
              []
            ]

        Just id ->
          Html.img
            [ Attributes.src ("https://res.cloudinary.com/username/image/upload/" ++ id) ]
            []
      ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  imageRead (ImageUpload << ImageRead)
```

**ports.js**
```javascript
var app = Elm.Main.fullscreen()
var globalReader = function () {
  var reader = new FileReader()

  reader.onload = ((event) => {
    app.ports.imageRead.send(event.target.result)
  })

  return reader
}()

app.ports.imageSelected.subscribe((id) => {
  var node = document.getElementById(id)
  if (node === null) {
    return
  }

  globalReader.readAsDataURL(node.files[0])
})
```
