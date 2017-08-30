# Count

This was created to manage things like z-index. Here's how we might manage
some z-index values manually:

```elm
layers =
    { normal = 1
    , dropdown = 2
    , menu = 3
    , modal = 4
    }
```

We might use it like so:

```elm
div
    [ class "menu"
    , style [ ( "z-index", toString layers.menu ) ]
    ]
    [ text "menu goes here" ]
```

This works, but if we want to add a new layer in the middle, or reorder any of
the existing layers, we have to redo all the numbering by hand.

## Using `Count`

`Count` offers a nicer alternative:

```elm
type alias Layers =
    { normal : Int
    , dropdown : Int
    , menu : Int
    , modal : Int
    }


layers =
    Count.to4 Layers
```

In both examples, the value of `layers` is the same.

In the second one, reordering the fields in the `type alias` causes them to be
renumbered automatically. Adding a fifth field necessitates only swapping out
`Count.to4` for `Count.to5`.

## Getting `map` involved

Let's say you want to transform each of the numbers before passing it along.
Maybe you want them to start from 0 instead of 1, which you could accomplish
by counting to 5 and then subtracting 1 from each value. Maybe you also want
to turn them into strings so you can pass them to `style` without having to
call `toString` on them every time.

Here's how you'd do that:

```elm
    type alias Layers =
        { normal : String
        , dropdown : String
        , menu : String
        , overlay : String
        , modal : String
        }


    layers : Layers
    layers =
        Count.mapTo5 (\num -> toString (num - 1)) Layers

    {-

        { normal = "0"
        , dropdown = "1"
        , menu = "2"
        , overlay = "3"
        , modal = "4"
        }

    -}
```

## That's it!

That's the whole library.
