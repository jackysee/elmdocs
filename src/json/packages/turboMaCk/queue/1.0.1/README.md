# Queue

[![Build Status](https://travis-ci.org/turboMaCk/queue.svg?branch=master)](https://travis-ci.org/turboMaCk/queue)

Simple **FIFO** (first in, first out) queue data structure. First element added to the `Queue` is the first one to be removed.
If you're interested in double-ended queue implementation please see [folkertdev/elm-deque](http://package.elm-lang.org/packages/folkertdev/elm-deque/latest).

**This package is highly experimental and might change a lot over time.**

Feedback and contributions to both code and documentation are very welcome.

# Performance

This implementation uses pair of `List`s
as described by Chris Okasaki's in his [Purely Functional Data Structures](https://www.cs.cmu.edu/~rwh/theses/okasaki.pdf)
(page 15). One list is used for dequeuing elements, the other one is used for enqueuing new ones. Items in enqueuing `List` are
stored in reversed order so adding new elements is cheap (*O(1)*). When last element is taken out from dequeuing list
rebalancing of `Queue` happens. Rebalacing is done by reversing enqueuing list and storing it as new dequeuing list. This is costly operation
(*O(n)*). However it shouldn't happen too often due to access from just one side of a `Queue`. Most of the time both
`enqueue` and `dequeue` happens in *O(1)*. `front` is guaranteed to be *O(1)*.
