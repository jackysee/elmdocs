# [The Elm Architecture][arch]

This package is an abstraction of [StartApp][start-app], which allows you to build up and create Signals of any type using [the Elm Architecture][arch]. You could decide to use the core `Graphics` module to write your view, or maybe you're making an app where the view is rendered by something else other than Elm. You would be able to follow the Elm Architecture, but supply a JSON encoder as the view function and send it out a port.

[arch]: https://github.com/evancz/elm-architecture-tutorial/
[start-app]: http://package.elm-lang.org/evancz/start-app/latest


## Example

The following chunk of code sets up a simple counter that you can increment and decrement. Notice that you focus entirely on setting up `model`, `view`, and `update`. That is it, no distractions!

```elm
import Graphics.Element exposing (show, flow, down)
import Graphics.Input exposing (button)
import Architecture.Simple as Architecture


main =
  Architecture.start { model = model, view = view, update = update }


model = 0


view address model =
  flow down <|
    [ button (Signal.message address Decrement) "-"
    , show model
    , button (Signal.message address Increment) "+"
    ]


type Action = Increment | Decrement


update action model =
  case action of
    Increment -> model + 1
    Decrement -> model - 1
```

## Further Learning

Check out the full documentation for this library [here](http://package.elm-lang.org/packages/deadfoxygrandpa/elm-architecture/latest/).

For more guidelines and examples of making apps in Elm, check out the following resources:

  * [Language Docs](http://elm-lang.org/docs) &mdash; tons of learning resources that go from syntax to language features to design guidelines.
  * [The Elm Architecture][arch] &mdash; simple examples demonstrating how our basic counter app can scale to huge applications that are easy to test, maintain, and refactor.
  * [elm-todomvc][] &mdash; a typical TodoMVC program ([live][]) built on the Elm Architecture. You will see the `model`, `update`, `view` pattern but for a more realistic application than a counter.
  * [dreamwriter][] &mdash; a writing app built in Elm that again uses the Elm Architecture. The creator has *never* had a runtime exception in his Elm code. Unlike JavaScript, Elm is designed for reliability that scales to any size.

[elm-todomvc]: https://github.com/evancz/elm-todomvc/blob/master/Todo.elm
[live]: http://evancz.github.io/elm-todomvc/
[dreamwriter]: https://github.com/rtfeldman/dreamwriter/
