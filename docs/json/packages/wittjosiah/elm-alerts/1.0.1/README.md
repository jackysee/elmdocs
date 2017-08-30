# elm-alerts

This is an alert message library for Elm.

Currently it forces use to use default Html for alerts, perhaps at some point I will separate the default into a submodule and allow custom Html.

## Usage

Add alerts to your model
```
type alias Model =
    { ...
    , alerts : Alert.Model
    }
```

Initialize alerts in your model

```
initModel : Model
initModel =
    { ...
    , alerts = Alert.initModel True
    }
```

Add alerts in your messages

```
type Msg
    = ...
    | AlertMsg Alert.Msg
```

Add alerts to your view

```
view : Model -> Html Msg
view model =
    div []
        [ ...
        , Html.map AlertMsg <| Alert.view model.alerts
        ]
```

Add alerts subscriptions

```
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ ...
        , Sub.map AlertMsg <| Alert.subscriptions model.alerts
        ]
```

Handle alert updates

```
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ... ->
        AlertMsg alertMsg ->
            let
                ( alerts, cmd ) =
                    Alert.update alertMsg model.alerts
            in
                ( { model | alerts = alerts }
                , Cmd.map AlertMsg cmd
                )
```

## Examples

Example of how to display an alert

```
button
    [ onClick <|
        AlertMsg <|
            Alert.AddAlert
                { type_ = Alert.Error
                , message = model.message
                , untilRemove = model.untilRemove
                , icon = model.icon
                }
    ]
    [ text "Error" ]
```

For a more complete example see the [examples folder](https://github.com/wittjosiah/elm-alerts/tree/master/examples).
