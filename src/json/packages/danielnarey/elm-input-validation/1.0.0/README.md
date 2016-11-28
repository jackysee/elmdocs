## Type-validation for user input from text, numeric, and custom fields

This library provides a consistent way of handling type-validation for user
input. The type of input expected is specified when constructing an input
element in the Elm program's view, and the corresponding reader function is
called when program updates in response to input. If the input does not match
the expected type, or the reader function called does not correspond to the type
expected, an error results.

__Dependencies:__
- [elm-lang/core/4.0.5](http://package.elm-lang.org/packages/elm-lang/core/4.0.5)
- [elm-lang/html/1.1.0](http://package.elm-lang.org/packages/elm-lang/html/1.1.0)
- [danielnarey/elm-toolkit/2.1.0](http://package.elm-lang.org/packages/danielnarey/elm-toolkit/2.1.0)

__Extensions:__
- [danielnarey/elm-form-capture](http://package.elm-lang.org/packages/danielnarey/elm-form-capture/latest)
