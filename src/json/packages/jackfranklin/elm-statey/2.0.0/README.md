# Statey

A state machine library, written in Elm. Very much a work in progress!

[View the docs on Elm Package](http://package.elm-lang.org/packages/jackfranklin/elm-statey/1.0.0/Statey).

The [example tests](https://github.com/jackfranklin/elm-statey/blob/master/test/ExampleTests.elm) aim to be a good Elm file to take as your starting point for using this library.

## Usage (taken from example tests)

```elm
module ExampleTests (..) where

{-| these tests serve as a good intro to the library
-}

import Statey exposing (..)
import ElmTest exposing (..)


type alias Person =
    StateRecord { name : String }


startState =
    makeState "start"


tiredState =
    makeState "tired"


sleepState =
    makeState "sleep"


stateMachine : StateMachine Person
stateMachine =
    { states = [ startState, tiredState, sleepState ]
    , transitions =
        [ ( startState, tiredState )
        , ( tiredState, sleepState )
        , ( sleepState, startState )
        ]
    , guards =
        [ { from = tiredState, to = sleepState, fn = \person -> person.name /= "Jack" }
        ]
    }


person =
    { name = "Jack", state = startState }


tiredPerson =
    { name = "Jack", state = tiredState }


tests : Test
tests =
    suite
        "Example tests"
        [ test
            "it can tell you the state of a record"
            (assertEqual startState (getState person))
        , test
            "it can transition a person through a state"
            (assertEqual
                (Ok { person | state = tiredState })
                (transition stateMachine tiredState person)
            )
        , test
            "but only if the transition is valid"
            (assertEqual
                (Err TransitionNotDefined)
                (transition stateMachine sleepState person)
            )
        , test
            "a guard that returns False stops a transition"
            (assertEqual
                (Err GuardPreventedTansition)
                (transition stateMachine sleepState tiredPerson)
            )
        ]
```

## Guards

You can also add guards into your state machine to protect against certain transitions:

```elm
guardedStateMachine =
    { states = [ startState, middleState, endState ]
    , transitions = [ ( startState, middleState ), ( middleState, endState ) ]
    , guards =
        [ { from = startState, to = middleState, fn = (\_ -> False) }
        ]
    }


person = { name = "Jack", state = startState }
-- invalid, guard from start -> middle returns False
case transition stateMachine middleState person of
    Ok newPerson -> ---
    Err err -> err == GuardPreventedTansition
```

Guard callbacks are passed the record:

```elm
-- the guard callback is given the record:

guardedStateMachine =
    { states = [ startState, middleState, endState ]
    , transitions = [ ( startState, middleState ), ( middleState, endState ) ]
    , guards =
        [ { from = startState, to = middleState, fn = (\person -> person.name /= "Jack") }
        ]
    }


person = { name = "Jack", state = startState }
-- invalid, person.name == "Jack"
case transition stateMachine middleState person of
    Ok newPerson -> ---
    Err err -> err == GuardPreventedTansition
```
