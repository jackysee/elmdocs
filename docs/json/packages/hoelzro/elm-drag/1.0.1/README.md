# elm-drag

This module listens for mouse events and creates drag events that
contain the delta x and y of the mouse's movement when the button is
pressed down.

Here's an example of an application that tallies the total distance
the mouse has been dragged:

```elm
import Html.App as App
import Html exposing (Html, text)

import Drag

type alias Model = {
    dragModel : Drag.Model,
    dragDistance : Int
  }

type Msg =
  DragMsg Drag.Msg |
  Drag (Int, Int)

init : (Model, Cmd Msg)
init =
  let initialModel = {
    dragModel = Drag.initialModel,
    dragDistance = 0
  } in (initialModel, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Drag.subscriptions DragMsg model.dragModel

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    DragMsg msg ->
      let (newDragModel, dragCmd) = Drag.update Drag msg model.dragModel
      in ({model | dragModel = newDragModel}, dragCmd)
    Drag (dx, dy) -> ({ model | dragDistance = model.dragDistance + (abs dx) + (abs dy) }, Cmd.none)

view : Model -> Html Msg
view model = text <| toString model

main : Program Never
main = App.program {
    init = init,
    update = update,
    subscriptions = subscriptions,
    view = view
  }
```
