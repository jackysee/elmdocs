When updating a component in a game, frequently you will want to have some state
for representing the death/destruction of the component. `Game.Update` offers
you convenient operations for chaining together update functions that have
side-effects and could kill the object, representing the alive state as `Just object` and
the death state as `Nothing`.

The results that this module creates are `Effects` from
[elm-effects](http://package.elm-lang.org/packages/akbiggs/elm-effects) --
knowing how to use that library is necessary before using this one.

```
import Game.Update as Update exposing (Update)
import Effects exposing (Effects)

-- in your game player
type alias Model =
    { velocity : { x : Float, y : Float }
    }

type Msg
    = Jump
    | TakeDamage

type Effect
    = PlaySound String
    | SpawnDustParticles

update : Msg -> Update Model Effect
update msg model =
    case msg of
        Jump ->
            Update.returnAlive
                { model | velocity = { model.velocity | y = 2.0 } }
                |> Effects.add [ SpawnDustParticles, PlaySound "jump.wav" ]

        TakeDamage ->
            Update.returnDead
                |> Effects.add [PlaySound "death.wav"]

-- in your game world

type alias Model =
    { player : Maybe Player.Model
    }

-- in your game world update somewhere
let
    -- update the player if the player is alive
    (updatedPlayer, playerEffects) =
        Update.runOnMaybe (Player.update Player.Jump) model.player
in
    { model | player = updatedPlayer }
        |> Effects.handle handlePlayerEffect playerEffects

```

