A `Ref` represents a "mutable" piece of data that might exist inside a larger data structure.
It exposes the current value of that data and encapsulates the information needed to update it.

Refs can simplify building modular UI components that know how to update themselves.
A typical module might look like this:

```elm
type alias Model =
    { foo: String,
    , widget: Widget.Model,
    , bloops: Array Bloop.Model
    }

-- an model-updating function
multiplyFoo : Int -> Model -> Model
multiplyFoo n model = {model | foo <- String.repeat n model.foo}


-- create Focus objects that represent fields of our Model type.
widgetField = Ref.focus .widget (\x m -> {m | widget <- x})
bloopsField = Ref.focus .bloops (\x m -> {m | bloops <- x})


view : Ref Model -> Html
view model =
    let
        -- create Refs to fields of our model record
        widget = Ref.map widgetField model
        bloops = Ref.map bloopsField model
    in
        div [] [
            -- model.value is our Model
            text model.value.foo,

            -- on click, perform an update
            button [onClick (transform model) (multiplyFoo 2)] [text "double it"],

            -- pass a nested component's model "by reference" to its module's view function 
            Widget.view widget,

            -- map over an array, passing elements "by reference" to a view function
            span [] (Array.Ref.map Bloop.view bloops)

            -- another update
            button [onClick (transform bloops) (Array.push (Bloop.init 55))] [text "new bloop"],
        ]


main : Signal Html
main = Signal.map view (Ref.new initialModel)

```

## Full examples

Ref-based versions of Counter, CounterPair, and CounterList
in the style of the Elm Architecture tutorial are
[here](https://github.com/karldray/elm-ref/tree/master/examples).

## Note on model-view separation

In this pattern, an Action type (as described in
[the Elm Architecture](https://github.com/evancz/elm-architecture-tutorial#the-elm-architecture))
is not part of a typical module's public API.
However, it's still good practice to keep model-manipulating code separate from view logic,
and you can still use an Action type to help with this.
Just partially-apply your update function when constructing event handlers:

```elm
onClick (transform model) (update MyAction)
```
