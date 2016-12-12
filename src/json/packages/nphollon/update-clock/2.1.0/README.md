# Update Clock

This module lets you update your model with a fixed time step. Even when the animation-frame updates come in fast or slow, your program will evolve smoothly and deterministically.

For a more detailed explanation of why fixed time steps are useful, check out [this article](http://gameprogrammingpatterns.com/game-loop.html).

## Example

In this snippet, the `physicsUpdate` function gets called 30 times per second.

```
type alias Model =
    { clock : Clock
    , particle : Particle
    }

type alias Particle =
    { position : Float
    , velocity : Float
    }

init : Model
init =
    { clock = Clock.withPeriod (33 * Time.millisecond)
    , particle =
        { position = 0
        , velocity = 1
        }
    }

update : Action -> Model -> Model
update action model =
    case action of
        TimeDelta dt ->
            let
                ( clock, particle ) =
                    Clock.update physicsUpdate dt model.clock model.particle
            in
                { model
                    | clock = clock
                    , particle = particle
                }

physicsUpdate : Time -> Particle -> Particle
physicsUpdate delta particle =
    { particle
        | position = particle.position + particle.velocity * delta
        , velocity = particle.velocity + acceleration * delta
    }
```