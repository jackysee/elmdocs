# elm-state

This library provides a different approach to handling of app state.
According to this idea the application state changing in time
by stream of state-mutating functions (updates).

```elm
import Html
import Time
import State

main = State.start state view updates

state = 0

view address state =
  Html.text <| toString state

updates =
  Signal.map (always <| (+) 1)
  <| Time.every Time.second
```
