# elm-jsonp

A small library that allows you to get data from a [JSONP](https://en.wikipedia.org/wiki/JSONP) endpoint.

### Description

The Jsonp module exposes a script function to define \<script\> tags, two "padding" functions and a Jsonp event handler.

### Scope

This was not meant for production use. The reason I made this is because when I started playing with Elm, I wanted to
get data from a JSONP endpoint and I couldn't find an Elm package to quickly help me with that.

### Usage

An example of how to use this, taken from the module's docs:

        type Msg
            = Response Value


        update : Msg -> Model -> (Model, Cmd Msg)
        update msg model =
            case msg of
                Response value ->
                    case (Json.Decode.decodeValue responseDecoder value) of
                        Ok data ->

                        Err msg ->


        view : Model -> Html Msg
        view model =
            div []
                [ script [ onJsonp Response ] [ text padding ]
                , script [ type_ "application/javascript", src "http://www.example.com/api/resource?callback=parseResponse" ] []
                ]

### Padding functions

There is basically one default padding function and a small variation of that, which instead of just requesting the
resource, it polls it. Their JavaScript code can be viewed in the module. You can always provide your own. As far as Elm
cares it's just a String.