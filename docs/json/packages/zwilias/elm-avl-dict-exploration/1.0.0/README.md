# Alternative Dict implementation backed by AVL tree [![Build Status](https://travis-ci.org/zwilias/elm-avl-dict-exploration.svg?branch=master)](https://travis-ci.org/zwilias/elm-avl-dict-exploration)

## Elevator pitch

Red-black trees as used in core's Dict require quite a few modifications for
rebalancing. Worse; they require quite a few comparisons to do the correct
modifications, which is notoriously slow in Elm. AVL trees offer similar
worst-case performance characteristics, but in this case, much better insertion
performance.

[Data!](https://plot.ly/dashboard/zwilias:12)

## Using Dict.AVL

`Dict.AVL` has the exact same API as core Dict, so using it can be accomplished
by simply doing something like this:

```elm
import Dict.AVL as Dict
```

## Contributing

The code itself distinguishes between the Tree and the Dict that's wrapped
around it. The tree has its own tests, to ensure all invariants hold at all
times.

The benchmarks have their own elm-package.json. Running them can be
accomplished by either `elm-make Main.Elm` within the benchmarks folder, or
running `elm-reactor`.

Whenever making pull-requests, please ensure there are no performance
regressions.


## TODO

- [ ] Create benchmarks for internal modifications (insertions and removals)
- [ ] Create benchmarks for `Dict.update`
- [ ] Check _why_ Char comparisons are that much slower
- [ ] Provide `Dict.AVL.Extra` - either in here or in a separate package
- [ ] Provide `Set.AVL` in a separate package
