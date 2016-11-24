# elm-timer

Timer module for use with the Elm Architecture, providing fine-grained timing via Effects.tick.

See example/Main.elm for an app that uses Timer to debounce an input value.

Note: I built this before realizing that **there is a much simpler solution available** using `Task.sleep`.  See example/Sleep.elm for that. So this package is maybe useful as an example of wiring in a sub-module that uses `Effects.tick` but is probably overkill for most timing needs.




