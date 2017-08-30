# elm-word

[![elm-package](https://img.shields.io/badge/elm-2.0.0-blue.svg)](http://package.elm-lang.org/packages/ktonon/elm-word/latest)
[![CircleCI](https://img.shields.io/circleci/project/github/ktonon/elm-word.svg)](https://circleci.com/gh/ktonon/elm-word)

Unsigned 32 or 64 bit integers and related operations.

Use the `Word` type to hold either 32 or 64 bit unsigned integers. Use the exposed type constructors `W` (for "word") and `D` (for "double word") to store values as words.

```elm
import Word exposing (Word(D, W))
```

## Operations

The following operations are provided.

* `add` - modulo addition
* `and` - bitwise and
* `xor` - bitwise xor
* `complement` - bitwise inversion
* `rotateRightBy` - [rotate right][]
* `shiftRightZfBy` - [logical shift right][]

Note that the set of operations is the minimal required to implement [SHA-2][].

## Examples

Addition of words is modulo 32 bits.
```elm
add (W 0x80000000)
    (W 0x80000003)
--> W 3
```

Addition of double words is modulo 64 bits.

```elm
add (D 0 0xFFFFFFFF)
    (D 0 1)
--> D 1 0
```

## Large Values in Elm

Double words are stored as two 32 bit values because Elm makes arithmetic mistakes with larger values. For example, try typing this into the `elm repl`:

```shell
$ elm repl

---- elm-repl 0.18.0 -----------------------------------------------------------

> 2 ^ 60 + 55 == 2 ^ 60
True : Bool
```

## Related Libraries

* [gilbertkennen/bigint][]: Work with integers of unlimited size.
* [mthadley/elm-byte][]: A library for working with 8-bit unsigned integers with type safety.


[gilbertkennen/bigint]:http://package.elm-lang.org/packages/gilbertkennen/bigint/latest/
[logical shift right]:https://en.wikipedia.org/wiki/Bitwise_operation#Logical_shift
[mthadley/elm-byte]:http://package.elm-lang.org/packages/mthadley/elm-byte/latest
[rotate right]:https://en.wikipedia.org/wiki/Bitwise_operation#Rotate_no_carry
[SHA-2]:https://en.wikipedia.org/wiki/SHA-2
