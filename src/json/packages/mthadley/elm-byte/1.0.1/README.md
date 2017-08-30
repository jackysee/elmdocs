# elm-byte

A library for working with 8-bit unsigned integers with type safety.

If you are trying to work with byte-sized values in your program, you can use the `Byte` type
exposed in this library instead of the native `Int`. This will give you better
type safety as you wont do things like accidentally add an `Int` somewhere and suddenly
have a value like `2340023`, where you meant to have something much smaller. This
can be particularly useful if you are trying to simulate hardware or other
low level, 8-bit operations.

```elm
module Example exposing (..)

import Byte
import Carry

result : Bool -- False
result =
  Byte.add (Byte.fromInt 132) (Byte.fromInt 245)
    |> Byte.toInt
    |> (<) 255

resultWithCarry : Bool -- True
resultwithCarry =
  Byte.addc (Byte.fromInt 132) (Byte.fromInt 245)
    |> Carry.check
```
