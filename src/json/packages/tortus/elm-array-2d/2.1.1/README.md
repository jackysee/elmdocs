# 2D Array library for Elm

2D array library implemented using nested elm Arrays.
Duplicates the elm Array API as much as possible, but with
a row and column for every element. Useful for making data grids,
is it provides row and column operations in addition to getting,
setting, and mapping over cells.

See the module docs for the complete list of operations: http://package.elm-lang.org/packages/tortus/elm-array-2d/latest/Array2D


```elm
let
  array2d =
    Array2D.fromList
      [ ["Row 1-Col 1", "Row 1-Col 2"]
      , ["Row 2-Col 1", "Row 2-Col 2"]
      ]

  changed =
    -- "Row 1-Col 1" becomes "NEW VALUE"
    Array2D.set 0 0 "NEW VALUE" array2d

  mappedArray =
    Array2D.indexedMap
      (\row col cell -> cell)
      changed
in
  -- Your app code here
  { model | dataGrid = mappedArray }
```

## Drawbacks and caveats

Most examples of nested models in Elm use Lists of elements with a
unique, constant ID, e.g.:

```elm
type alias Cell = { uid : Int, ... }
```

This allows messages to always be routed to the correct
element, even if elements are re-ordered, removed, added, etc.
If you use the **index** of an element instead to create a long Task
that will change the element when it ends, be aware that the target
element's index may have changed during the task!

For data grids you are probably not going to be re-positioning
cells. Most data grids simply modify cells in place, which is what
Array2D is mainly intended for. **The danger comes from inserting and
deleting rows and columns.** During such operations, you may want to
temporarily make your grid "read-only" somehow.
