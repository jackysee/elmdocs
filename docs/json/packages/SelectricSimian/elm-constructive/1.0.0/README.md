# elm-constructive

elm-constructive makes it easier to work with a variant of [the Elm architecture](https://github.com/evancz/elm-architecture-tutorial) in which actions contain updated versions of the model, as opposed to instructions for how to update the model.  This is less declarative than the standard Elm architecture, but it makes certain forms of view composition easier.

By essentially bypassing the `update` step, it is possible to avoid most of the tag-based and id-based routing logic that is normally necessary to update a deeply-nested component.  With this architecture, the updated model is *constructed* from the bottom up, rather than the existing model being modified from the top down.

## Simple example: increment/decrement counters

```Elm
-- elm-constructive
viewCounter address counter =
  div []
    [ button [ onClick address (Replace (counter + 1)) ] [ text "+" ]
    , button [ onClick address (Replace (counter - 1)) ] [ text "-" ]
    , text (toString counter)
    ]


-- Standard Elm architecture
viewCounter address counter =
  div []
    [ button [ onClick address Increment ] [ text "+" ]
    , button [ onClick address Decrement ] [ text "-" ]
    , text (toString counter)
    ]
```

Notice how in elm-constructive, the actions being sent hold new values for the model (`Replace (counter + 1)`, `Replace (counter - 1)`), whereas in the standard Elm architecture the actions hold instructions for how to update the model (`Increment`, `Decrement`).

The benefits of this approach appear when composing views.  Suppose we wanted to view a list of counters.  [A common approach is to assign each counter a unique identifier, then tag and route each action according to the identifier of the counter it belongs to](https://github.com/evancz/elm-architecture-tutorial#example-3-a-dynamic-list-of-counters).  This works well, but it requires a bit of boilerplate, and introduces extra state into the model for managing identifiers.  In elm-constructive, no identifiers are needed, and the entire list-viewing logic fits on a single line using the `viewList` combinator:

```Elm
viewCounterList address counterList =
    div [] (viewList viewCounter address counterList)
```

This works because, with elm-constructive, actions produced by sub-views (in this case, individual counters) don't ever need to be routed back to their appropriate location in the model; the entire new model is *constructed* directly, in one pass, as the sub-views' actions "bubble up" the composition hierarchy.

`viewList` is just one of many ways that views can be composed in elm-constructive.  Along with several built-in combinators, it is easy to write your own combinators on top of the elm-constructive foundation.

## A word of warning

elm-constructive is nothing more than an exploration of what patterns and abstractions can emerge from the Elm architecture.  I am in no way suggesting that this approach is either the best or the only way to architect Elm applications.  In particular, constructing updated models in the action-handling logic of view code threatens the separation of concerns between update logic and view logic.  I suspect that judicious refactoring of update logic into separate modules and functions can maintain the separation of concerns in elm-constructive just as well as in the standard Elm architecture, but elm-constructive certainly seems to make it easier to accidentally mix the two.  It is also unclear how well elm-constructive interacts with [tasks](http://package.elm-lang.org/packages/evancz/elm-effects/2.0.1/) and [virtual DOM keys](http://package.elm-lang.org/packages/evancz/elm-html/4.0.2/Html-Attributes#key).
