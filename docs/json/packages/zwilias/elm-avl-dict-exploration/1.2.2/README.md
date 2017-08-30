# Alternative Dict implementation backed by AVL tree [![Build Status](https://travis-ci.org/zwilias/elm-avl-dict-exploration.svg?branch=master)](https://travis-ci.org/zwilias/elm-avl-dict-exploration)

## Elevator pitch

Red-black trees as used in core's Dict require quite a few modifications for
rebalancing. Worse; they require quite a few comparisons to do the correct
modifications, which is notoriously slow in Elm. AVL trees offer similar
worst-case performance characteristics, but in this case, much better insertion
performance.

## Performance

You can find a little write up on the benchmarks and the methodology on [this page](http://elm-avl-dict-bench.surge.sh).

## Using Dict.AVL

`Dict.AVL` has the exact same API as core Dict, so using it can be accomplished
by simply doing something like this:

```elm
import Dict.AVL as Dict
```

There is one exception - checking for equality. Since core's Dict is special
cased in elm ecosystem for equality checks, and we can't use this same special
case due to a different internal structure, you'll need to use the
`Dict.AVL.eq` function.

```elm
import Dict.AVL as Dict

left = Dict.fromList [(0, ()), (1, ())]
right = Dict.fromList [(1, ()), (0, ())]

-- This will return False
left == right

-- This works as expected and returns True
Dict.eq left right
```
