# Tuple Extra

Additional helpers for working with tuples.

For example:

```elm
foo (x, y) = (baz x, y)
```

becomes

```elm
foo = mapSnd baz
```
