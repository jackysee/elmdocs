# Focus More

Adds a couple of helpful "Setters" (or "Lenses" or "Foci" or whatever).

This library is ment as a small extension of the `SwiftNamesake/please-focus` package.
Usually imported together like this:

```elm
import Focus exposing (Setter, (&), (.=), (=>), ($=))
import FocusMore as Focus exposing (FieldSetter)
```

Also here's my free trick for handling Union-type Models:

```elm
import Focus
import FocusMore as Focus

type alias InActionModel = ...

type alias NotInActionModel = ...

type Model
    = UserInAction InActionModel
    | NotInAction NotInActionModel

-- Define the "Setters" which only set,
-- when the model is in the respective case
userInAction : Focus.FieldSetter Model InActionModel
userInAction f model =
    case model of
        UserInAction inAction ->
            UserInAction (f inAction)

        _ ->
            model

notInAction : Focus.FieldSetter Model NotInActionModel
notInAction f model =
    case model of
        NotInAction notInAction ->
            NotInAction (f notInAction)

        _ ->
            model
```

Now you can use these Setters in your update function:

```elm
update : ...
update msg model =
    case msg of
        UserActionMsg actionMsg ->
            model & userInAction $= updateInAction actionMsg

        ... ->
            ...
```
