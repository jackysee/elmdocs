# Tools for composing comparison functions

Some types like strings and numbers are comparable in Elm by default. Elm has built in functions like `List.sort`, `List.minimum`, `List.maximum`, `Basics.min`, and `Basics.max` that make use of the possiblity to compare them.

For performing these operations on your own types you'll need to write a custom comparison function. This library contains some tools for building and using such comparison functions.
