# Stateful [![Build Status](https://travis-ci.org/sgraf812/elm-stateful.svg)](https://travis-ci.org/sgraf812/elm-stateful)

A small library with primitives for working with stateful computations. This is neat when trying to imitate mutable variables, for example random number seeds or just generating automatically incrementing ids like so:

```
nextId : Stateful Int Int
nextId =
  Stateful.get `Stateful.andThen` \id ->
  Stateful.put (id + 1) `Stateful.andThen` \_ ->
  Stateful.return id

threeIds : List Int
threeIds =
  fst <| Stateful.run
    (Stateful.sequence
      [ nextId
      , nextId
      , nextId
      ])
    3
-- threeIds = [3, 4, 5]
```

The advantage here is that we don't need to manually thread a counter variable in a let binding.