# Alternative prompt / defered signals
This is an experimental package: I wanted to see what an alternative world would look like where Elm distinguished between defered signals (signals that start out "empty") and prompt signals (signals that are created with an initial value in the first position).

## Disclaimer

This is an experiment - please don't use it in production. It's probably not very performant to use `foldl` on either prompt or defered signals right now since there is quite a lot of magic making this work...

## Usage

Use `Signal.foldl` like you would `List.foldl` or `Array.foldl`

```elm
import Signal.Extra       -- See Apanatshka/elm-signal-extra

Signal.foldl f x signal == Signal.Extra.foldp' f (flip f x) signal
```

`Defered.foldl` is similar to `Signal.foldp` except that a `foldl`-like seed value is used, instead of an initial value.

```elm
Signal.foldp f (f initial seed) signal == prompt (f initial seed) (Defered.foldl f seed (defer signal))
```

`Defered.foldl` relates to `Signal.foldl` as follows.

```elm
prompt initial (Defered.foldl f seed defsig) == Signal.foldl f (prompt (f initial seed) defsig)
```

## Examples

Sometimes it is not clear that a signal what the initial value of a signal should be.
One example is a mouse click, a discrete signal that appears to trigger only on after initialization has completed. This is called a defered signal in this library, I.e. `Defered.Signal ()`

```elm
import Signal.Alt as Signal
import Signal.Alt (Signal)
import Signal.Defered as Defered
import Mouse.Defered as Mouse

-- Produces a defered signal that looks like this: <1,2,3,4,5,...>
clicksCounter : Defered.Signal Int
clicksCounter = Defered.foldl (\c -> c + 1) 0 Mouse.clicks

-- Produces a prompt signal that looks like this: <Nothing,Just "1",Just "2",Just "3",Just "4",Just "5",...>
displayedClicks : Signal Int
displayedClicks = Singal.prompt Nothing <| (Just << toString <~ clicksCounter)
```
