# unique-id

[![Build Status](https://travis-ci.org/league/unique-id.svg?branch=master)](https://travis-ci.org/league/unique-id)

Pure generation of unique identifiers in Elm.

Sometimes we need unique identifiers attached to some parts of a data structure
so we can identify them for analysis and processing. Therefore it's convenient
to have a source from which we can acquire unique IDs. In an impure language,
we'd just designate a mutable integer variable `nextId` and then use `nextId++`
wherever a uniqueId is needed. That doesn't work in a pure language, but this
library makes it relatively convenient.

We specify computations within the `Unique` type, and then `run` that
computation to allocate all the identifiers within the computation. Within one
invocation of `run`, all the generated `Id` values are guaranteed to be unique.
However, multiple invocations of `run` will generate conflicting `Id`s.

`Unique` computations can be specified with the typical `andThen` and `map`
operations. The function `unique` generates the next `Id` and `return` produces
a constant value.

There is an extended example in `tests/Example.elm`. It defines a binary tree
data structure where the leaves will hold a value of any type and also be
marked with a `Unique.Id`:

```elm
type Tree a
  = Branch (Tree a) (Tree a)
  | Leaf a Unique.Id
```

We define the alias `TreeGen` to describe a computation that produces a `Tree`:

```elm
type alias TreeGen a = Unique.Unique (Tree a)
```

Then by providing these alternative constructors:

```elm
leaf : a -> TreeGen a
leaf a = Unique.map (Leaf a) Unique.unique

branch : TreeGen a -> TreeGen a -> TreeGen a
branch left right = Unique.map2 Branch left right
```

we can produce trees within `Unique` like this:

```elm
example : TreeGen a
example = branch (leaf "xen") (branch (leaf "yow") (leaf "zip"))
```

The leaves will be labeled with `Id`s 0, 1, and 2:

```
> toString (Unique.run example)
Branch (Leaf "xen" (Id 0)) (Branch (Leaf "yow" (Id 1)) (Leaf "zip" (Id 2)))
```

Suppose now we want to splice a new tree into an existing tree at a certain
leaf. We can specify the `Id` of the leaf to be replaced, and do the entire
computation within `Unique` (via the `TreeGen` alias):

```elm
splice : Unique.Id -> TreeGen a -> Tree a -> TreeGen a
splice id subst tree =
  case tree of
    Leaf x k ->
      if k == id then subst
      else leaf x
    Branch left right ->
      branch (splice id subst left) (splice id subst right)
```

The `Example` module continues with a UI that renders binary trees as nested
boxes: brown-bordered boxes for branches and green boxes for leaves. When you
hover over one of the leaves, it will splice the other tree onto that point and
show the result.

![Screenshot from example showing tree 1 spliced into tree 2](https://raw.githubusercontent.com/league/unique-id/master/tests/tree-identity.png)

This library fulfills a similar role to the
[`Data.Unique`](https://hackage.haskell.org/package/base-4.9.0.0/docs/Data-Unique.html)
module in Haskell.
