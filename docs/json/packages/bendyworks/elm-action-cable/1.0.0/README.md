# ActionCable in Elm

This package is an Elm client library for [ActionCable][ActionCable guide], which comes bundled with Ruby on Rails.

## Basic Usage

```elm
import ActionCable
import ActionCable.Msg as ACMsg
import ActionCable.Identifier as ID


initModel : (Model, Cmd Msg)
initModel =
    { cable =
        ActionCable.initCable "ws://localhost:3000/cable/"
            |> ActionCable.onDidReceiveData (Just HandleData)
            |> ActionCable.withDebug True
    , errorToast = Nothing
    , ...
    } ! []


type Msg
    = CableMsg ACMsg.Msg
    | SubscribeTo String
    | UnsubscribeFrom String
    | HandleData ID.Identifier Json.Decode.Value
    | SendData String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubscribeTo roomName ->
          subscribeTo roomName model

        UnsubscribeFrom roomName ->
          unsubscribeFrom roomName model

        HandleData identifier value ->
            -- value is a Json.Decode.Value. You'll probably want to use
            -- Json.Decode.decodeValue
            { model | messages = toString value :: model.messages } ! []

        SendData roomName aStringToSend ->
          sendData roomName aStringToSend model

        CableMsg cableMsg ->
            -- important to forward on "accounting" messages to the underlying submodel
            ActionCable.update cableMsg model.cable
                |> (\( cable, cmd ) -> { model | cable = cable } ! [ cmd ])


subscribeTo : String -> Model -> (Model, Cmd Msg)
subscribeTo roomName model =
    case ActionCable.subscribeTo (channelId roomName) model.cable of
        Ok ( cable, cmd ) ->
            { model | cable = cable } ! [ Cmd.map CableMsg cmd ]

        Err err ->
            -- you're probably already subscribed to this channel
            { model | errorToast = Just <| ActionCable.errorToString err } ! []


unsubscribeFrom : String -> Model -> (Model, Cmd Msg)
unsubscribeFrom roomName model =
    case ActionCable.unsubscribeFrom (channelId roomName) model.cable of
        Ok ( cable, cmd ) ->
            { model | cable = cable } ! [ Cmd.map CableMsg cmd ]

        Err err ->
            -- you're probably already unsubscribed from this channel
            { model | errorToast = Just <| ActionCable.errorToString err } ! []


sendData : String -> String -> Model -> (Model, Cmd Msg)
sendData roomName aStringToSend model =
    let
        sendCmd =
            ActionCable.perform
                "some_channel_action_name"
                [ ( "jsonKey", Json.Encode.string aStringToSend ) ]
                (channelId roomName)
                model.cable
    in
        case sendCmd of
            Ok toSend ->
                model ! [ toSend ]

            Err err ->
                -- probably because you haven't subscribed to the channel yet
                { model | errorToast = Just <| ActionCable.errorToString err } ! []


channelId : String -> ID.Identifier
channelId roomName =
    ID.newIdentifier "ChatChannel" [ ( "room", roomName ) ]


-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    ActionCable.listen CableMsg model.cable
```


## License

`elm-action-cable` is released under the Apache v2 license, the details of which can be found in the LICENSE file.

## Author

* [Brad Grzesiak](https://twitter.com/listrophy), [Bendyworks](http://bendyworks.com)


[ActionCable guide]: http://guides.rubyonrails.org/action_cable_overview.html "ActionCable guide"
