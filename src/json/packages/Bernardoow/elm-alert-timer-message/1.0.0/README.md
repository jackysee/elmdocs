# elm-alert-timer-message



A Alert Timer Message component in Elm.

You can pass any Html Msg to component. The Html will be displayed for few seconds and then disapper.

Tip: Add CSS to Html Msg for display hots Alerts.



## Usage

The component need a Alert Timer Message Model on your model like this:

```elm
    type alias Model =
        { alert_messages : AlertTimerMessage.Model }
```

The view will be update based on this model. Component expose `modelInit` for init.

```elm
initial : Model
initial =
    Model AlertTimerMessage.modelInit
```

The Component can be displayed in a view using the AlertTimerMessage.view function. It returns its own message type so you should wrap it in one of your own messages using Html.map:
```elm
type Msg
    = ...
    | AlertTimer AlertTimerMessage.Msg
    | ...
```
```elm
view : Model -> Html Msg
view model =
    ...
    div [] [
            Html.map AlertTimer (AlertTimerMessage.view model.alert_messages)
        ]
```
In order handle `Msg` in your update function, you should unwrap the `AlertTimerMessage.Msg` and pass it
down to the `AlertTimerMessage.update` function. The `AlertTimerMessage.update` function returns the Component Model updated.

```elm
update : Msg -> Model -> ( Model, Cmd, Msg )
update msg model =
    case msg of
        ...

        AlertTimer msg ->
            let
                ( updateModal, subCmd ) =
                    AlertTimerMessage.update msg model.alert_messages
            in
                { model | alert_messages = updateModal } ! [ Cmd.map AlertTimer subCmd ]


```

When you want display message, send a elm message to component like this:

```elm
        AddNewMessage ->
            let
                newMsg =
                    AlertTimerMessage.AddNewMessage 10 <| div [] [ text "MSG Teste" ]

                ( updateModal, subCmd ) =
                    AlertTimerMessage.update newMsg model.alert_messages
            in
                { model | alert_messages = updateModal } ! [ Cmd.map AlertTimer subCmd ]
```

This alert will be displayed for 10 seconds.


## Examples

See the [examples][examples] folder

[examples]: https://github.com/Bernardoow/elm-alert-timer-message/tree/master/examples
[toastr]: https://github.com/CodeSeven/toastr

Thanks for [toastr]. I used your css on one example.
