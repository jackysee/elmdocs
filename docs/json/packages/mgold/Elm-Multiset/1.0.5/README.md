# Multiset for Elm

Represent a collection of counted elements in [Elm](elm-lang.org), by Max Goldstein.

**NOTICE:** This package is being renamed `mgold/elm-multiset`, lowercase, for compatibility.

Documentation is provided for each function. Submit bugs, requests, and the like through GitHub.

Multisets are wrappers around Dicts, which (as of 0.16) do not support
equality. Therefore the library provides an `equals` function. It considers
missing values to equal values of zero. However, values of zero are removed by
the library anyway. If you can create a value of zero without using the Dict
library directly, it's a bug so please report it.

To run the tests, run `elm reactor` in the top level and navigate to `test/test.elm`.
