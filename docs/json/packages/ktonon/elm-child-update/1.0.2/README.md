# elm-child-update

Delegates update messages to one or many children. Takes the grunt work out updating a collection of children. This small [Elm][] package exposes the `ChildUpdate` module with just two functions:

* `updateOne` for updating a child in a one-to-one parent to child relationship
* `updateMany` for updating a list of children in a one-to-many parent to child relationship

The more useful function is `updateMany`. Consider a child model called `Widget`.

```elm
module Widget exposing (..)

import ChildUpdate


-- MODEL


type alias Model =
    { id : Id
    , someOtherStuff : String
    , dotDotDot : Int
    }


type alias Id =
    String



-- UPDATE FOR PARENT


type alias HasMany model =
    { model | widgets : List Model }


updateMany : (Id -> Msg -> msg) -> Id -> Msg -> HasMany m -> ( HasMany m, Cmd msg )
updateMany =
    ChildUpdate.updateMany update .id .widgets (\m x -> { m | widgets = x })



-- UPDATE


type Msg
    = DoSomething
    | DoSomethingElse


update : Msg -> Model -> ( Model, Cmd Msg )
-- arbitrary update implementation
```

Two things are noteworthy here:

* the `Widget.Model` has an identifier which is implicitly unique (the `id`)
* not only does the module define an update function, but it also provides a helper called `updateMany` which can be used by parent modules

The unique identifier is required, but it's name and type are arbitrary. `Widget.updateMany` is defined by currying the first four arguments of `ChildUpdate.updateMany`. The first two curried arguments are

* the child's `update` method
* the getter for the unique identifier (i.e. `.id`)

The last two arguments define getters and setters for the list of widgets on the parent's model. This is making an assumption and placing a restriction on how the parent model will be defined. The type alias `HasMany` documents this assumption. This is just an example usage, you may also choose not to curry these two arguments and leave it for the parent module to provide.

Given this setup, a parent module can make use of `Widget.updateMany` as follows:

```elm
module SomeUserOfWidget exposing (..)

import Widget


-- MODEL


type alias Model =
    { widgets : List Widget.Model
    , otherThing: String
    }



-- UPDATE


type Msg
    = WidgetMessage Widget.Id Widget.Msg
    | KaBam
    | KaBoom


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WidgetMessage id cMsg ->
            Widget.updateMany WidgetMessage id cMsg model

    -- the rest ...
```

The parent just has to define a message for wrapping `Widget` identifier and message pairs. Then it can delegate the update to the appropriate child using the exposed `Widget.updateMany` function and passing in:

* the message wrapper (i.e. `WidgetMessage`)
* the unique identifier and child message (as just unwrapped from `WidgetMessage`)
* the parent's model

The result, of `Widget.updateMany` will be a parent model with updated `widgets` and any child command properly wrapped with `WidgetMessage`.

[Elm]: http://elm-lang.org/
