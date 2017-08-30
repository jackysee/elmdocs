# Element Relative Mouse Events

This package is a handful of the mouse event functions from `Html.Events`, except they return the position of the mouse click relative to the element itself. So if you were to click in the middle of a 200 x 200 div, `onClick` would pass along `Point 100 100` to its `Point -> msg`.

## History

We made this package for [Elm-Canvas](https://github.com/Elm-Canvas/elm-canvas). But it became clear that mouse events are outside of the scope of Elm-Canvas, even if many use cases of Elm-Canvas could use some mouse events

## Alternatives

[mbr](https://github.com/mbr/elm-mouse-events/tree/1.0.4) has a good package that does nearly the same thing as this package. The key difference is that mbr's returns a record with the target and client positions that can be used to figure out the element-relative positon of the click. This one tries to calculate that behind the scenes and just return the position.