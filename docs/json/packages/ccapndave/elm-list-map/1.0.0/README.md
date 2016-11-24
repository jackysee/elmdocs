# elm-list-map

An Elm package that implements a key value store a a simple `List` of pairs.  Although this is horribly
inefficient, it allows you to have any values as the key without having to worry about implementing
comparators or hash functions.

Useful if you know that you aren't going to have a very long list.