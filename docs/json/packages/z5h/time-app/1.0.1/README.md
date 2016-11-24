# What is this?

This is a fork of Evan Czaplicki's [StartApp](https://github.com/evancz/start-app) for Elm.

If you are here, you should first understand how [StartApp](https://github.com/evancz/start-app) works. Read up.

If you want to know why this exists, read [this](https://github.com/evancz/start-app/issues/24).

OK, now that you've read that and are an expert at StartApp, know that:  
StartApp has been renamed to TimeApp and StartApp.Simple has been renamed to TimeApp.Simple.

The important change is TimeApp.Simple's update has signature:

```elm
update : action -> Time -> model -> model
```

As opposed to StartApp.Simple's update signature of:

```elm
update : action -> model -> model
```

That simply means your **update function receives Time as an argument** so you know at what time update was called. This is nice because in a pure functional language you can't just "ask for the current time".

TimeApp has been similarly modified so as to have:

```elm
update : action -> Time -> model -> (model, Effects action)
```

as opposed to StartApp's:

```elm
update : action -> model -> (model, Effects action)
```

# Example


```elm

import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import TimeApp.Simple as TimeApp
import StartTime
import Time exposing (Time)

main =
  TimeApp.start { model = model, view = view, update = update }

model : {count : Int, prevEventTime : Maybe Time, eventTime : Maybe Time}
model =
  { count = 0
  , prevEventTime = Nothing
  , eventTime = Nothing
  }

view address model =
  let
    timeBetweenUpdatesMessage =
      case (model.prevEventTime, model.eventTime) of
        (Just prevTime, Just time) ->
          ((time - prevTime ) / 1000.0 |> toString) ++ " seconds between updates."
        _ -> ""
  in
    div []
      [ button [ onClick address Decrement ] [ text "-" ]
      , div [] [ text <| (toString model.count)]
      , div [] [ text <| timeBetweenUpdatesMessage ]
      , button [ onClick address Increment ] [ text "+" ]
      , div [] [ ]
      ]

type Action = Increment | Decrement

update action time model =
  case action of
    Increment -> {count = model.count + 1, eventTime = Just time, prevEventTime = model.eventTime}
    Decrement -> {count = model.count - 1, eventTime = Just time, prevEventTime = model.eventTime}

```
