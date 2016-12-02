# Elm DictSet

Library containing two types of sets: `DictSet` and `IdSet`

examples are in the [test](test) folder.

## DictSet
A Set that contains ordinal values, backed by a Dict. The ordinal value of
items in a DictSet are specified by the ord method that is given whenever a
DictSet is constructed.

## IdSet
A Set with a built in id generator. These ids are used as keys for the Dict.
