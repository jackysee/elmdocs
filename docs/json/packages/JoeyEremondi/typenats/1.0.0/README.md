# typenats
Helpers for type-level natural-numbers in Elm.

These are useful when describing things like multi-dimensional arrays or lists of fixed length, ensuring that a certain number of elements exist.

These aren't very useful on their own, but you can use them as tags to provide
a type-safe API for an underlying function that is safe, but can't be proven
safe by the compiler.

See the [safelist](http://package.elm-lang.org/packages/JoeyEremondi/safelist) library for an example of this.

Was formerly elm-typenats, but changed to meet the new naming guidelines.

Example: integers whose values are stored in the type

```elm
import TypeNat exposing (Zero, OnePlus)


-- Our parameterized by a type-level number
-- Usually you won't want to export the constructor, 
-- so you can restrict the types of values we create
type SingleInt n = SingleInt Int


-- We make fake-constructors for our parameterized type
-- This allows us to ensure the values match the type
singleZero : SingleInt Zero
singleZero = SingleInt 0


singleOnePlus : SingleInt n -> SingleInt (OnePlus n)
singleOnePlus (SingleInt n) = SingleInt (n+1)

```

