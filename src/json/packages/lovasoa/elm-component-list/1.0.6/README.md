# elm-component-list
A generic Elm list component, that, given a component type, creates a list of it.

## Example

[See it running online](https://lovasoa.github.io/elm-component-list).
```elm
-- EXAMPLE
-- simple component that prints a hello button
cModel = "Hello"
cUpdate v _ = v
cView cmodel = input [onInput identity, value cmodel] []
main =
  App.beginnerProgram {
    model = init cModel,
    view = view (ViewParams "New hello" "Delete this hello") cView,
    update = update cUpdate
  }

```
