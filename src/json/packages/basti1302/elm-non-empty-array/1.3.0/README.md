# Array.NonEmpty for Elm
[![Build Status](https://travis-ci.org/basti1302/elm-non-empty-array.svg?branch=master)](https://travis-ci.org/basti1302/elm-non-empty-array)

An array that always contains at least one element.

Additionaly, it can track a currently selected index, which is guaranteed to
point to an existing element in the array.

These additional constraints enables two functions, namely `getFirst` and
`getSelected` to return a value directly instead of a `Maybe`.

The implementation uses [Skinney/elm-array-exploration](http://package.elm-lang.org/packages/Skinney/elm-array-exploration/latest) internally (which will be the default Array implementation in Elm core from version 0.19 on). For Elm 0.18, `Skinney/elm-array-exploration` is the only dependency besides `elm-lang/core`. For Elm 0.19, `elm-lang/core` will be the only dependency.

Inspired by [mgold/elm-nonempty-list](http://package.elm-lang.org/packages/mgold/elm-nonempty-list/latest).

````elm
import Array.NonEmpty as NEA exposing (NonEmptyArray)


oneElement : NonEmptyArray
oneElement = NEA.fromElement 13

twoElements : NonEmptyArray
twoElements = NEA.push 42 one

createdFromList : Maybe NonEmptyArray
createdFromList = NEA.fromList ["a", "b", "b"]
````

All functions from core `Array` are available, with the exception of `isEmpty` (which would be an alias for `False`).

In addition, non-empty-array offers additional functions made possible due to the additional constraints:

* `getFirst`: Returns the first element. Since it is known that this element exists, this function does not return a Maybe but the actual element type.
* `getSelected`: Returns the element at the currently selected index. Since it is known that this element exists, this function does not return a Maybe but the actual element type.
* `updateSelected`: Updates the element at the currently selected index.


Finally, it offers `update`, `removeAt` and `removeAtSafe`, which are not in core `Array` but inspired by `Array.Extra`.


## Tests

The easiest way to run the tests is to install the npm packages `elm-test` and `elm-verify-examples` globally:

```
npm i elm-test -g
npm i elm-verify-examples -g
```

Then, from the project root directory, run

```
elm-verify-examples && elm-test
```

This will require downloading some packages on the first run.

## Version History

* 1.2.0 - 2017-07-02: Add update, updateSelected and setSelectedIndexAndReport
* 1.1.1 - 2017-07-01: Fix typo in README
* 1.1.0 - 2017-06-30: Selected index feature
* 1.0.0 - 2017-06-30: Initial version

## License

This library uses the BSD3 License. See LICENSE for more information.
