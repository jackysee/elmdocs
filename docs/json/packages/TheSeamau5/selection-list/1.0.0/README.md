## selection-list

A selection list is a collection that keeps track of which item in the collection is currently selected. This data structure is especially useful when working with components such as tabs, pages, slideshows and anything pagination related.

```elm
type alias SelectionList a =
  { previous : List a
  , selected : a
  , next     : List a
  }
```

### Create a selection list

You can easily create a selection list from a list and a default value

```elm
mySelectionList : SelectionList Int
mySelectionList =
  fromList 1 [2, 3, 4, 5]
```

This selection list will have 1 as its first and selected value and the list will be the next values.


### Change selected values

You can also easily move along the selection list. If you wish that `2` be selected, you can just call `next`

```elm
mySelectionList2 =
  next mySelectionList
```

We can query for the selected index with the dot syntax

```elm
mySelectionList2.selected -- 2
```

We can also go to the previous element

```elm
mySelectionList3 =
  previous mySelectionList2 -- 1
```

Or go to an nth element

```elm
mySelectionList4 =
  goto 3 mySelectionList -- 4
```


### Mapping over a selection list

You can map over a selection list

```elm
mySelectionList5 =
  map (\x -> x * x) mySelectionList
```

You can map by index

```elm
mySelectionList6 =
  indexedMap (\index x -> index + x) mySelectionList
```

or you can apply different behaviors depending on whether the element is selected or not

```elm  
mySelectionList7 =
  selectedMap (\isSelected x -> if isSelected then -1 else x) mySelectionList
```

### Querying a selection list

You can ask how long the selection list is

```elm
length mySelectionList -- 5
```

or you can ask for the index of the selected element in the selection list

```elm
selectedIndex (next mySelectionList) -- 1
```

Note that the selection list is 0-based and thus the first element is the 0th element.

### Convert to a list

Finally, you can convert a selection list to a list

```elm
toList mySelectionList -- [1, 2, 3, 4, 5]
```
