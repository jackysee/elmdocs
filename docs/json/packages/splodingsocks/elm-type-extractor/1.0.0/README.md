# Extract Types

This small module will take a string of Elm source, and extract all top-level type declarations.

For example, some source that looks like this:

```Elm
foo : String
foo = "Foo"

bar : Int -> Int
bar i = i + 1
```

Would return a list of type declarations, looking like this:

```Elm
[ {identifier = "foo", type' = "String"}
, {identifier = "bar", type' = "Int -> Int"}
]
```
