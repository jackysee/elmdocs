# elm-notification [![](https://img.shields.io/badge/documentation-1.1.1-yellow.svg?style=flat-square)](http://package.elm-lang.org/packages/KtorZ/elm-notification/latest/) ![](https://img.shields.io/badge/license-MPL%202.0-blue.svg?style=flat-square) ![](https://img.shields.io/badge/gluten-free-green.svg?style=flat-square)


Easily display toast notifications to users. The module defines four common alert levels (success,
info, warning and error) and takes care of managing toast lifecycles.

See the [demo](https://ktorz.github.io/elm-notification) to get a nice overview of the capabilities.

# Install it

```bash
elm package install KtorZ/elm-notification
```

# Use it

Within your app, first connect the effects runner to a port (or alternatively, merged it into
one of your effects signal that is already bound to a port).

```elm
port notifications : Signal (Task Effects.Never ())
port notifications =
  Notification.task
```

Then, fold on the view signal and display a view accordingly:

```elm
view : Html -> Html
view notifications =
  div [] [notifications] 

main =
  Signal.map view Notification.view
```

To actually send a notification, use the `address` provided by the module:

```elm
view : Html -> Html
view notifications =
  let
    controls = button [onClick Notification.address (Notification.info "Elm rocks!")] [text "Go"]
  in
    div [] [notifications, controls]
```

# TODOs

- Allow colors and easing animations to be configured

# Change log

### 1.0.0 (2016-04-27)

- First version, display notifications of four different types


