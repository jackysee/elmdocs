IntRange
========

The library provides fold/map* funcsions for the range of Int numbers avoiding consuming extra memory.

IntRange.foldl/foldr/map/map2 can be used replacement of List Int value which represents certain range of Int values.

This is useful when iterate vast numbers avoiding consuming extra memory.

For example,

```
      import IntRange (to)
      import IntRange
      Import List

      IntRange.foldl (+) 0 (0 `to` 100000000) -- Can be calculate without consuming extra memory.
      List.foldl (+) 0 [0..100000000] -- Requires memory for the List of Int which length is 100000000.
```

Both of List.foldl and IntRange.foldl don't consumes call stack (those are using Trampoline), but List.foldl version consumes memory for the list [0..100000000], in the contrast of IntRange.fold requres relatively small constant memory.
