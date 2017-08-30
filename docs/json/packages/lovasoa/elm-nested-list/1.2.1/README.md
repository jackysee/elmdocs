# lovasoa/elm-nested-list

[![Build Status](https://travis-ci.org/lovasoa/elm-nested-list.svg?branch=master)](https://travis-ci.org/lovasoa/elm-nested-list)

Nested lists (`[[1,2,[3]],4]`) in Elm.

## What does this do ?

This simple package allows handling nested lists in Elm.

It provides a type

```elm
type NestedList a
    = Element a
    | Nested (List (NestedList a))
```

as well as functions to work with this type, including a JSON encoder and
a decoder.

## test

Just run `npm install && npm test`
