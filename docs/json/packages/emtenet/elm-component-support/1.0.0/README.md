# elm-component-support

> Support for building applications from Elm components

This Elm package is an exploration of how components interact with each
other and how to compose components from other components.

The exploration is described in more detail in the [index.md](docs/index.md).

# Component structure

Each component is structure along the following lines:

```elm
module X exposing ( Msg (PublicEvent, ...), Model, init, update, view, subscriptions)

type Msg
    = PrivateMsg
    | ...
    | PublicEvent
    | ...

type alias Model = 

init: ... -> Model
init ... =

update : Msg -> Model -> Update.Action Msg Model
update msg model =

view : (Msg -> msg) -> Model -> Html msg
view tag model =

subscriptions : (Msg -> msg) -> Model -> Sub msg
subscriptions tag model =
```

The basic structure follows [The Elm Architecture](http://guide.elm-lang.org/architecture/index.html) but with a few notable differences:

1.  Update functions return a `Update.Action` that can describe a
    combination of:
    * updating the model,
    * forwarding messages to child components,
    * returning events to the parent component,
    * request a command to be performed

    Use functions in the [`Update`](Update) module to create these actions.

2.  The `view` function receive a `tag` function
    (also referred to as a `tagger` function)
    that is used to convert your component's message type 
    to the parent component's message type.

    This allows components to be combined at the view level with out
    introducing any additional messages/events, and with out the container
    component knowing the workings of the contained component.

    See: [view-composition.md](docs/view-composition.md)

3.  The `Msg` union type is used to return events to the parent component.

    There are alternative methods to communicate with the parent component and
    those are discussed in
    [communicate-with-parent.md](docs/communicate-with-parent.md).
    A couple of the alternatives all work with the `Update` functions but only
    one alternative (perhaps the simplest) has been used in the documentation.

    The `Msg` type contains both private messages to the component and
    optionally some public events. Remember to only expose the public
    events in your `module X exposing` list.

> TODO: The `init` function cannot yet request commands to be performed.

## An example component

Lets jump into an example component. This example is part of the full example
application found in the [examples/2-counter-pair](examples/2-counter-pair)
directory.

```elm
module CounterPair exposing (Msg, Model, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Component.Update as Update
import Counter

-- MODEL

type Msg
    = Reset
    | Top Counter.Msg
    | Bottom Counter.Msg

type alias Model =
    { top : Counter.Model
    , bottom : Counter.Model
    }

init : Int -> Int -> Model
init top bottom =
    { top = Counter.init top
    , bottom = Counter.init bottom
    }

-- UPDATE

update : Msg -> Model -> Update.Action Msg Model
update msg' model =
    case msg' of
        Reset ->
            Update.model (init 0 0)

        Top msg ->
            Update.component msg model.top (Top) (\x -> { model | top = x }) Counter.update

        Bottom msg ->
            Update.component msg model.bottom (Bottom) (\x -> { model | bottom = x }) Counter.update

-- VIEW

view : (Msg -> msg) -> Model -> Html msg
view tag model =
    div []
        [ Counter.view (tag << Top) model.top
        , Counter.view (tag << Bottom) model.bottom
        , button [ onClick (tag Reset) ] [ text "RESET" ]
        ]
```

Things to take note of:

1.  The `update` function calls [`Update.model`](Component-Update#model) 
    when it wants to modify the model.
    A related [`Update.ignore`](Component-Update#ignore) function is useful
    when you do not want to change the model, or perform any other action.

2.  Child components have their own `Msg` tag (`Top` and `Bottom` in this example),
    their own model value (`model.top` and `model.bottom`).

    The [`Update.component`](Component-Update#component) function does the
    hard work of integrating the child components actions into your own.
    It will take care of things like not updating your model 
    if the child did not update it's own model.

    [`Update.component`](Component-Update#component) needs to be given the
    childs `Msg` tag so it can return events and a function to change your
    model when the child's model is updated.

3.  Child views are created with out the use of `Html.App.map` but do require
    you to combine the passed `tag` with the child components tag.
    For example:

    ```elm
    Counter.view (tag << Top) model.top
    ```

4.  `Html.Events` also need to be tagged correctly, examples include:

    ```elm
    type Msg
        = StartSearch
        | SearchText

    Html.div []
        [ Html.input [ onInput (tag << SearchText) ] []
        , Html.button [ onClick (tag StartSearch) ] [ text "Search" ]
        ]
    ```

# Try the examples

This repo contains a few examples showing usage of this Elm package.
Download this repo with:

```bash
git clone https://github.com/emtenet/elm-component-support.git
```

Try an example by changing to the example directory and running `elm-reactor`:

```bash
cd elm-component-support/examples/1-counter
elm-reactor
```

Now go to [http://localhost:8000/](http://localhost:8000/) and click on `Main.elm`.