# Self-balancing binary search trees, in Elm.

[Self-balancing binary search trees](https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree) are a node-based data structure that allow amortized worst case asymptotic `O (log n)` lookup, insertion and removal, as well as `O (n)` enumeration.

## Basic tree operations

> Type signatures in this section assume a Tree type has been imported *and*
> exposed.

There are only a few operation that need to be implemented on a tree to allow
the construction of a more complete set of operations.

### Construction

First of all, we'll need some constructors.

```elm
Tree.empty : Tree comparable
Tree.singleton : comparable -> Tree comparable
```

`empty` allows creation of the empty, *null* tree. This is useful as a target
for folding or comparison to other nodes.

Using the `singleton` constructor, we can create a tree for one single *comparable* value.

### Manipulation and inspection

Other than construction, we'll also need some operations to manipulate and
inspect the tree.

```elm
Tree.insert : comparable -> Tree comparable -> Tree comparable
Tree.remove : comparable -> Tree comparable -> Tree comparable
Tree.member : comparable -> Tree comparable -> Bool
```

`insert` and `remove` speak for themselves: allowing the insertion into and
removal of nodes from a tree, means we can actually store the exact data we
want in a tree, and remove it once it is no longer required or once it needs to
be removed. Of course, without a way of knowing whether an element is in the
tree, we can't do much with it. So, we also need a `member` function that will
check if a given `comparable` appears in a given `Tree`.

### Folding

```elm
Tree.foldl : (comparable -> a -> a) -> a -> Tree comparable -> a
Tree.foldr : (comparable -> a -> a) -> a -> Tree comparable -> a
```

Finally, there is the pair of folding functions `foldl` and `foldr` that allow
enumerating the values in a tree, passing them into an accumulator and finally,
returning this accumulated value. This accumulator could be any type of value,
like a single value (for example, to sum all the elements of a tree), a list or even a tree. Note that this enumeration happens in `O (n)`.

Using this last case -- folding a tree into another tree -- allows arbitrary
types of manipulation. For example, removal of a node *could* be implemented as
folding all values *except the node to be removed* into a new tree. Of course,
that means the performance for removal would drop to `O (n)` rather than `O
(log n)`, so that's not how it's implemented.

However, a whole host of other operations could be defined -- in a rather
performant manner -- in terms of folding. `map`, `filter`, `toList`, `size`,
`union`, `intersect`, `partition` and `difference` are a few standard
operations that may be implemented this way, with example implementations given
below.

## Fold-based operations

This section is a quick overview of operations that can efficiently and often
succinctly be implemented in terms of a fold.

### toList

Convert tree to list in ascending order, using `foldl`.

*Example implementation:*

```elm
toList : Tree comparable -> List comparable
toList =
    foldl (::) []
```

### fromList

Create tree from list by folding over the list and inserting into an initially empty tree. Folds over the list, rather than the tree.

*Example implementation:*

```elm
fromList : List comparable -> Tree comparable
fromList =
    List.foldl insert empty
```

### size

Foldl over the list and incrementing an accumulator by one for each value that passes through the accumulator operation.

*Example implementation:*

```elm
size : Tree comparable -> Int
size =
    foldl (\_ acc -> acc + 1) 0
```

### map

Fold over the tree, executing the specified operation on each value, and
accumulating these values into a new tree.

*Example implementation:*

```elm
map : (comparable -> comparable2) -> Tree comparable -> Tree comparable2
map operator =
    foldl
        (insert << operator)
        empty
```

### filter

Create a new set with elements that match the predicate.

*Example implementation:*

```elm
filter : (comparable -> Bool) -> Tree comparable -> Tree comparable
filter predicate =
    foldl
        (\item ->
            if predicate item then
                insert item
            else
                identity
        )
        empty
```

### union

Union is implemented by folding over the second tree and inserting it into the
first tree.

*Example implementation:*

```elm
union : Tree comparable -> Tree comparable -> Tree comparable
union =
    foldl insert
```

### intersect

Tree intersection creates a new Tree containing only those values found in both
trees. This is implemented by filtering the right-hand set, only keeping values
found in the left-hand set.

*Example implementation:*

```elm
intersect : Tree comparable -> Tree comparable -> Tree comparable
intersect left =
    filter (flip member left)
```

### difference

The differences between two trees is, in Elm land, defined as the elements of
the left tree that do not exists in the right tree. As such, this is
implemented by filtering the left tree for values that do not exist in the
right set.

```elm
diff : Tree comparable -> Tree comparable -> Tree comparable
diff left right =
    filter (not << flip member right) left
```

### partition

Similar to filtering, this does not throw away the values that do not match the
predicate, but creating a second tree from those values. The resulting trees
are then returned as a tuple.

*Example implementation:*

```elm
partition : (comparable -> Bool) -> Tree comparable -> ( Tree comparable, Tree comparable )
partition predicate =
    foldl
        (\item ->
            if predicate item then
                Tuple.mapFirst <| insert item
            else
                Tuple.mapSecond <| insert item
        )
        ( empty, empty )
```
