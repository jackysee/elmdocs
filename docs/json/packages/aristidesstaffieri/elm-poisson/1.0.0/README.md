##Elm Poisson

[Poisson WIKI](https://en.wikipedia.org/wiki/Poisson_distribution)

Poisson distributions are useful for determining probability of events
that happen over a fixed period of time if the events have a known
average rate and are independent of time since last event.

```
import Poisson exposing (..)
import Html exposing (text)

main =
  text <| toString <| poisson 1 1
```
