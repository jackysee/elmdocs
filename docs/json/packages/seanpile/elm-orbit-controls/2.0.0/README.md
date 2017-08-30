# elm-orbit-controls
An Elm library that provides the ability to orbit an object in space around a target.  This library is a port of other orbit control implementations:

* [orbit-controls](https://github.com/Jam3/orbit-controls)
* [three.js](https://github.com/mrdoob/three.js/blob/dev/examples/js/controls/OrbitControls.js)

# Dependencies

This project requires the use of the  [elm-community/linear-algebra](https://github.com/elm-community/linear-algebra) package for Vectors and Matrices.

# Documentation

See the generated documentation in the [elm package repository](http://package.elm-lang.org/packages/seanpile/elm-orbit-controls/latest)

# Basic Example

```elm
import OrbitControls
import Math.Vector3 exposing (Vec3)

type alias Model = {
  -- You must keep track of the state in your model
  state: OrbitControls.State,

  -- We want to orbit the camera around a target
  cameraPosition: Vec3
}

-- Include a Msg that can receive Orbit events
type Msg =
  OnOrbit OrbitControls.OrbitEvent

init : ( Model, Cmd Msg )
init =
  ( { state = OrbitControls.defaultState }, Cmd.none)

-- Add listeners to the DOM element you are embedding your content in
view : Model -> Html Msg
view model =
  div (OrbitControls.listeners model.state OnOrbit)
      [ WebGL.toHtml ... ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    OnOrbit event ->
      let
        ( updatedCamera, updatedState ) =
          OrbitControls.apply
            event
            ( model.cameraPosition, model.state )

        -- Do something with the new camera position
        ...
      in
        -- Keep track of the updated state
        ( { model | state = updatedState }, Cmd.none )


```
