
A first-in, first-out queue ([FIFO](https://en.wikipedia.org/wiki/FIFO_(computing_and_electronics))) backed by lists.

```bash
elm-package install avh4/elm-fifo
```

## Basic API

```elm
empty : Fifo a

insert : a -> Fifo a -> Fifo a

remove : Fifo a -> (Maybe a, Fifo a)
```


## Example

```elm
import Fifo

main =
    Fifo.empty
    |> Fifo.insert 7
    |> Fifo.insert 42
    |> Fifo.remove |> snd
    |> Fifo.remove |> fst
    |> toString
    |> Html.text
        -- Shows "Just 42"
```
