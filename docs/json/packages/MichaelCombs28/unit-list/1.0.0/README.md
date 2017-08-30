# UnitList

When working with Elm, a main source of bugs is representation of
states that should be impossible but are not. This library provides
a list with a focus and at least a single element.


## Example

Say we're writing a Journal app where each journal contains at least
a single entry.

```elm

type alias Journal =
    { entries : UnitList Entry
    , route : Route
    }

type alias Entry =
    { title : String
    , body : String
    }

type Route
    = Http404
    | EntryR

type Msg
    = NextEntry
    | NewEntry
    | PreviousEntry

update : Msg -> Journal -> (Journal, Cmd Msg)
update msg model =
    case msg of
        NextEntry ->
            case UnitList.next model.entries of
               Just m ->
                   { model
                       | entries = m
                       , route = EntryR
                   } ! []

               Nothing ->
                   { model | route = Http404 } ! []

        NewEntry ->
            UnitList.archive (Entry "New Entry" "") model.entries
                |> \e -> { model | entries = e } ! []

        PreviousEntry ->
            case UnitList.previous model.entries of
                Just m ->
                    { model
                        | entries = m
                        , route = EntryR
                    } ! []

                Nothing ->
                    { model | route = Http404 } ! []
```

We've eliminated the possibility of a Journal without an Entry and
added the previous Entry to the history which we can then revisit.
