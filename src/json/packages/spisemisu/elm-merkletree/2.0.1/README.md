# Merkle Tree

This is an implemenation of
the [Merkle tree](https://en.wikipedia.org/wiki/Merkle_tree) data structure in
Elm. It's implemented as an immutable balanced binary hash tree, which
guarantees for logarithmic inserts. Default hash function
is
[**SHA-2**56](https://en.wikipedia.org/wiki/SHA-2#Comparison_of_SHA_functions)
but others can be used. Hash functions are specified on initiation and can't be
changed afterwards which ensures data consistency.

To use, simply import the main namespace:

    import Merkle 

or specific type and/or function(s):

    import Merkle
        exposing
            ( Tree
            , initialize
            , singleton
            , fromList
            , insert
            , insertFromList
            , get
            , depth
            , flatten
            , contains
            , isValid
            , toJson
            , fromJson
            )
