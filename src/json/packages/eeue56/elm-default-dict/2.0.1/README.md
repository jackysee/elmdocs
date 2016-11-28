# elm-default-dict


Use default dictionaries in Elm!

```elm
-- create a default dictionary with the value 0
ages : DefaultDict String Int
ages =
    DefaultDict.empty 0

-- equal to 5
mikesAge =
    DefaultDict.insert "Mike" 5 ages
        |> DefaultDict.get "Mike"

-- equal to 0
someoneElse =
    DefaultDict.get "David" ages

everyonesAges : DefaultDict String Int
everyonesAges =
    DefaultDict.fromList
        100
        [ ("Mike", 5)
        , ("David", 0)
        , ("Tommy", 19)]

-- equal to 100
leesAge =
    DefaultDict.get "Lee" everyonesAges
```


## When should I use this?

Whenever you want a dictionary to have a default value. The implementation is roughly
70% identical to core's Dict, meaning that the API mirrors it exactly.

The increased size overhead is `4 * size of v`. v is stored on each of the `RBEmpty` leafs.

## Interesting notes

Due to the way that `toString` works internally, our `DefaultDict` can get pretty printing for free by using the same types used to implement `Dict`.

