# Bytes

A library for fast immutable `Bytes`. The type is built on top of `Core`'s
immutable `Array` type limited to values of `Int` in the range of `0` - `255`.

To use, simply import the main namespace:

    import Bytes

or specific function(s):

    import Bytes 
        exposing 
            (Bytes
            , empty
            , fromList
            , fromBytes
            , fromUTF8
            , fromHex
            , isBytes
            , isEmpty
            , isHex
            , length
            , toArray
            , toList
            , toString
            )
