# Dollar

This library provides a `Dollar` type that wraps an `Int`.

```elm
type Dollar
```

 This adds greater type safety to your function than a simple type alias would
by guaranteeing you can't mistakenly pass a `Dollar` where you meant to use some
other type of `Int` or mistakenly trying to add a `Dollar` value with another
`Int`.

The `Dollar` module provides a bunch of helper functions to make it easy to
perform operations on the wrapped value as well as some generic helpers to allow
you to write your own operations. For example, given this type:

```elm
type alias Person =
  { age : Int
  , savings : Int
  }
```

this incorrect function will compile:

```elm
totalCoupleSavings : Person -> Person -> Int
totalCoupleSavings person1 person2 =
  person1.savings + person2.age
```


Now change `Person` to use a `Dollar` rather than an `Int`:

```elm
type alias Person =
  { age : Int
  , savings : Dollar
  }
```

now the broken `totalCoupleSavings` function will cause a compilation error
since `Dollar` and `Int` cannot be added together.

The correct implementation of `totalCoupleSavings` now looks like:

```elm
totalCoupleSavings : Person -> Person -> Dollar
totalCoupleSavings person1 person2 =
  Dollar.add person1.savings person2.savings
```
