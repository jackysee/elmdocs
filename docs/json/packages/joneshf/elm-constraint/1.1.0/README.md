# elm-constraint

An experiment with constraints.

## Motivation

This is useful for expanding on ideas already present. For instance, there are many functions in `List` that use `comparable`. This is a fine function if all you have is primitives:

```elm
> min 3 4
3 : number
```

But it is not so fine if you have something a bit more complex:

```elm
> min (Just 3) (Just 4)
==================================== ERRORS ====================================

-- TYPE MISMATCH --------------------------------------------- repl-temp-000.elm

The 1st argument to function `min` is causing a mismatch.

5|   min (Just 3) (Just 4)
          ^^^^^^
Function `min` is expecting the 1st argument to be:

    comparable

But it is:

    Maybe number

Hint: Only ints, floats, chars, strings, lists, and tuples are comparable.
```

There is no reason this type error has to exist. This library explores one (of many) ways to get around the type error.

## Tutorial

### min

Let's start by re-implementing the current `min` from `Basics` naively. We can do this using `compare : comparable -> comparable -> Order`:

```elm
min : comparable -> comparable -> comparable
min x y =
  case compare x y of
    LT ->
      x
    _ ->
      y
```

Let's try to implement our own version using constraints.

First, let's change the type to something we can work with. `comparable` is a keyword in elm, not a regular type variable, so we cannot use it for our purpose. With no strong reason to prefer any other word, let's alpha rename to `a`.

```elm
min' : a -> a -> a
```

Note that we haven't added any constraints yet. Taking a very small step, we can specify that we want to include some constraints in the type. Since we don't know what the constraints are yet, let's just call them `r`:

```elm
min' : a -> a -> Constraint r a
```

Since we know we'll need to use something like `Basics.compare` to implement `min'`, we want a constraint that can provide an appropriate function. Let's use the `Ord` constraint from `Constraint.Ord`, since provides a `compare : a -> a -> Order`.

```elm
min' : a -> a -> Constraint (Ord a r) a
```

Note that we have pushed the `r` into the `Ord` constraint. We do this so that we are not restricted to **only** having the `Ord` constraint. There are reasons you might want to restrict, and reasons you might not want to. For the sake of this tutorial, we're not going into that.

Now that we've got our type all put together, let's start implementing the function. We can take two `a` arguments like in `min`, but the return value isn't a plain `a` value. Since we know we're going to use the `compare` function, we can `ask` for the constraints up front and transform—`map`—the value from there. To make things slightly less cluttered, we use `(<&>)` instead of `map`.

```elm
min' : a -> a -> Constraint (Ord a r) a
min' x y =
  ask <&> \c ->
    ...
```

The rest of the implementation is the same as `min` above, assuring that we use the appropriate `compare`.

```elm
min' : a -> a -> Constraint (Ord a r) a
min' x y =
  ask <&> \c ->
    case c.compare x y of
      LT ->
        x
      _ ->
        y
```

Let's recap the steps we took.

1. Constrain the type signature
1. `ask` for the constraints.
1. Implement the same logic as before.

We can check to see how well this works (using `Constraint.Ord` as it already implements these functions and a bit more):

```elm
> import Constraint exposing (..)
> import Constraint.Ord as CO
> CO.min
<function> : b -> b -> Constraint.Constraint (Constraint.Ord.Ord b c) b
> CO.min 3 4
Constraint <function>
    : Constraint.Constraint (Constraint.Ord.Ord number b) number
> CO.min 3 4 |> with {compare = compare}
3 : number
> CO.min (Just 3) (Just 4)
Constraint <function>
    : Constraint.Constraint
        (Constraint.Ord.Ord (Maybe.Maybe number) b) (Maybe.Maybe number)
> CO.min (Just 3) (Just 4) |> with (CO.ordMaybe {compare = compare})
Just 3 : Maybe.Maybe number
```

It is very important to note that we are not forced to use `Basics.compare` here, we do so only for convenience. We could go through and re-implement `compare` for all built-in types, but this tutorial is already pretty long :).

The idea shown here can be extended to more complex functions like `List.minimum` or `List.sort`. The idea can be used to provide a data type like `Dict.Dict k v` that works with any `k` so long as an `Ord k r` constraint can be given. Meaning, you could have a dict like data type that worked with `Maybe a`, `List a`, or any other data type as the keys if you needed. In this regard, it would be very similar to `AllDict`.
