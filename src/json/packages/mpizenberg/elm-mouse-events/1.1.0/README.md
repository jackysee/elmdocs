# elm-mouse-events [![][badge-license]][license]

[badge-doc]: https://img.shields.io/badge/documentation-latest-yellow.svg?style=flat-square
[doc]: http://package.elm-lang.org/packages/mpizenberg/elm-mouse-events/latest
[badge-license]: https://img.shields.io/badge/license-MPL%202.0-blue.svg?style=flat-square
[license]: https://www.mozilla.org/en-US/MPL/2.0/

This package aims at handling mouse events in elm
with more details than in `Html.Events`.


## Motivation

When dealing with mouse events, I often need to access mouse coordinates.
Functions `onMouseDown` and others from elm `Html.Events` module do not
provide the coordinates of the mouse event.

Thanks to the use of the `on` function from `Html.Events` and some
custom json decoders, this package provides mouse events with coordinates.


## Usage

A functional example is available in the `examples/` folder.
But to have an overview of how to use this package, see below
what a `Msg` type and an `Attribute Msg` might look like using this Mouse module:

```elm
import Mouse

type Msg
    = MouseDown Mouse.Event
    | MouseMove Mouse.Event
    | MouseUp Mouse.Event

mouseEvents : List (Html.Attribute Msg)
mouseEvents =
    [ Mouse.onDown MouseDown
    , Mouse.onMove MouseMove
    , Mouse.onUp MouseUp
    ]
```


## The Mouse.Event type

The `Mouse.Event` type is a reflection of the [JavaScript specification of a mouse event][mouse-event-mdn].
The attributes kept are:

 * [altKey][alt-key]
 * [ctrlKey][ctrl-key]
 * [shiftKey][shift-key]
 * [clientX][clientX]
 * [clientY][clientY]
 * [offsetX][offsetX]
 * [offsetY][offsetY]
 * [movementX][movementX]
 * [movementY][movementY]

Go see it's definition in the `Mouse` module to know its exact record structure.

[mouse-event-mdn]: https://developer.mozilla.org/en/docs/Web/API/MouseEvent

[alt-key]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/altKey
[ctrl-key]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/ctrlKey
[shift-key]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/shiftKey

[clientX]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientX
[clientY]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientY
[offsetX]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetX
[offsetY]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetY
[movementX]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/movementX
[movementY]: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/movementY


## Documentation

The package documentation is available on the [elm package website][doc].


## License

This Source Code Form is subject to the terms of the Mozilla Public License,v. 2.0.
If a copy of the MPL was not distributed with this file,
You can obtain one at https://mozilla.org/MPL/2.0/.


## Authors

Original author: Matthieu Pizenberg (matthieu.pizenberg@gmail.com)
