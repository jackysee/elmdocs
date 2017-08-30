# difference-list

[![Build Status](https://travis-ci.org/league/difference-list.svg?branch=master)](https://travis-ci.org/league/difference-list)

An Elm-language representation of lists with an efficient append operation.

This is particularly useful for efficient logging and pretty printing, where
repeatedly appending lists quickly becomes too expensive. Internally, `DList`
is a function that prepends elements to its parameter. Thus the `append`
operation is just function composition. Ultimately, a `DList` is converted to a
regular `List` by applying the function to the empty list.

Some limitations of the `DList` representation are:

  - We cannot ask for the length of a `DList` without converting it to a
    regular list.

  - We cannot test equality on two `DList` structures without converting them
    to regular lists.

See also: <http://package.elm-lang.org/packages/league/difference-list/>
