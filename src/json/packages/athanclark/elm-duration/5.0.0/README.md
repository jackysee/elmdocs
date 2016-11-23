## Elm-Duration

A helper component for issuing actions every browser frame with some easing functions,
over some time duration.

```elm
type alias MyModel =
  { someComponent : MyComponent.Model
  , duration : Duration.Model
  }

initMyModel : MyModel
initMyModel =
  { someComponent = MyComponent.init
  , duration = Duration.init
  }

type MyMsg
  = ComponentMsg MyComponent.Msg
  | DurationMsg Duration.Msg

updateMyModel : MyMsg -> MyModel -> (MyModel, Cmd MyMsg)
updateMyModel action model =
  case action of
    ComponentMsg a ->
      let (newComponent, eff) = Component.update a model.someComponent
      in  ( { model | someComponent = newComponent }
          , Cmd.map ComponentMsg eff
          )
    DurationMsg a ->
      let (newDuration, eff) = Duration.update
                                 (\t -> Task.perform Debug.log ComponentMsg <|
                                          Task.succeed <| MyComponentVisibility <|
                                            outQuad <| t / (2*second)
                                 )
                                 (2 * second)
                                 a
                                 model.duration
      in  ( { model | duration = newDuration }
          , eff
          )

subscriptions : MyModel -> Sub MyMsg
subscriptions = Sub.map DurationMsg <| Duration.subscriptions model.duration

view : MyModel -> Html MyMsg
view model =
  div []
    [ viewMyComponent model.someComponent
    , button [ onClick <| DurationMsg <| Duration.Forward <|
                            \_ -> Task.perform Debug.log ComponentMsg <|
                                    Task.succeed TransitionComplete
             ] [text "Start animation"]
    ]

```
