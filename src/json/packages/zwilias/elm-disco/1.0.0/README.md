# Elm Disconnected views explorations

```elm
view : View Store msg
view =
    with q.items <|
        \items ->
            List.map renderTodo items |> div []


renderTodo : String -> View Store msg
renderTodo item =
    with q.intro <|
        \intro ->
            div []
                [ text intro
                , text item
                ]
```

The idea is that views can be explicitly asked for some info, but can also ask
for info themselves.

This works through queries that know how to extract some info from a store:

```elm
type alias Store =
    { todo : List String
    , otherThing : String
    }


q :
    { items : Query Store (List String)
    , intro : Query Store String
    }
q =
    { items = .todo >> List.reverse
    , intro = .otherThing
    }
```

The "secret" here is that the store is _actually_ passed around, you just can't
access it. Not directly. Tadaa.
