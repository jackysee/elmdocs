elm-ternary [![Build Status][ci-svg]][ci-url]
==================

[ci-svg]: https://circleci.com/gh/rogeriochaves/elm-ternary.svg?style=shield
[ci-url]: https://circleci.com/gh/rogeriochaves/elm-ternary

This simple package provides infix functions for shorter if/then/else
conditionals, known as ternary, and a "null" coalescing operator for Maybes.

```elm
import Ternary exposing ((?), (?:))

exampleTernary =
  (1 + 1 == 2) ? "Math works!" <| "Math is wrong ):"

exampleNullCoalescing =
  Just "foo" ?: "bar"
```
