## Capture form input as a dictionary keyed by component id

The Elm `Html` package lacks a set of built-in functions for capturing input
from a form with multiple fields, and implementing form capture from scratch
can be tricky. The `FormCapture` library makes it easy to capture form input by
abstracting out a lot of the implementation details. You only need to specify an
`id` string and input type key for each form element, and the rendering function
uses that data to generate a decoder that will be applied on a `submit` event.
The HTML specification for each form element is entirely customizable using
standard `Html` or the alternative
[`HtmlTree`](http://package.elm-lang.org/packages/danielnarey/elm-html-tree/)
syntax.

__Dependencies:__
- [elm-lang/core/5.0.0](http://package.elm-lang.org/packages/elm-lang/core/5.0.0)
- [elm-lang/html/2.0.0](http://package.elm-lang.org/packages/elm-lang/html/2.0.0)
- [danielnarey/elm-toolkit/3.0.0](http://package.elm-lang.org/packages/danielnarey/elm-toolkit/3.0.0)
- [danielnarey/elm-html-tree/1.0.2](http://package.elm-lang.org/packages/danielnarey/elm-html-tree/1.0.2)
- [danielnarey/elm-input-validation/1.0.1](http://package.elm-lang.org/packages/danielnarey/elm-input-validation/1.0.1)
