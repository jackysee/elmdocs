# elm-avl
```shell
elm-package install careport/elm-avl
```

AVL tree-based Dicts and Sets for Elm, using explicit comparison
functions.

## Motivation
The standard library already includes `Dict` and `Set` types, but they
require the use of `comparable` keys, and there is no way to extend
the set of types that are `comparable`. The data structures defined
in this package, on the other hand, allow the use of arbitrary key
types, since they require the user to provide an explicit comparison
function. **Therefore, the user must be careful to always provide the
*same* comparison function to the same data structure. Otherwise, the
results of various functions will be unpredictable.**

## Usage
Given some type that you want to use as a dictionary key or a set
element, you first need to define a comparison function on
it. For example:
```elm
import Avl.Set as Set

type alias Person = { name : String, age : Int }

personCompare : Person -> Person -> Order
personCompare p1 p2 =
    compare p1.name p2.name

let
    people =
        [ { name = "Doe, John", age = 40 }
        , { name = "Smith, Jane", age = 25 } ]
in
    Set.fromList personCompare people
```

The example above uses the built-in `compare` function over strings,
but that isn't always necessary:
```elm
type Peano = Zero | Succ Peano

peanoCompare : Peano -> Peano -> Order
peanoCompare n1 n2 =
    case (n1, n2) of
        (Zero, Zero) ->
            EQ

        (Zero, _) ->
            LT

        (_, Zero) ->
            GT

        (Succ m1, Succ m2) ->
            peanoCompare m1 m2
```
