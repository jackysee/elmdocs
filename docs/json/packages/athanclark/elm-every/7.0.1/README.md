# Elm-Every

Repeatidly issue an action, with some time frame in-between.

It's pretty simple to integrate, all you need is:

- a function to determine how much time to wait until the next issue, based on
  the total time waited so far: `Time -> Time`
- an action to issue, with some data it would expect to apply with

Then, to start the poller, you issue `Start` with some data you would want the
action to use. To update this data, just make another call to `Start`. Then,
to stop the poller, just issue `Stop`.


```elm
import Every


type alias EveryState =
  { kickoffCount : Int
  }

type alias MyModel =
  { mySession : SessionModel
  , poller    : Every.Model EveryState
  }

initMyModel : MyModel
initMyModel =
  { mySession = initSession
  , poller    = Every.init
  }

type MyAction
  = SessionMsg SessionMsg
  | EveryMsg (Every.Msg EveryState)
  | KickStart

-- we're calculating the time to add to the total, based on the current total.
fibbDelay : Maybe EveryState -> Time -> Time
fibbDelay _ total = total

issueMsg : Maybe EveryState -> Msg
issueMsg ms =
  -- ...


updateModel : MyAction
           -> MyModel
           -> (MyModel, Cmd MyAction)
updateModel action model =
  case action of
    SessionMsg a ->
      let (newSession, eff) = updateSession a model.mySession
      in  ( { model | mySession = newSession }
          , Cmd.map SessionMsg eff
          )
    EveryMsg a ->
      let (newEvery, eff) = updateEvery
                              fibbDelay
                              issueMsg
                              a
                              model.poller
      in  ( { model | poller = newEvery }
          , Cmd.map (\r -> case r of
                             Err x -> x -- resolve issued data
                             Ok  x -> EveryMsg x) eff
          )
    KickStart ->
      ( model
      , Task.perform (Debug.crash << toString) EveryMsg
        <| Every.Start { resetSoFar = True
                       , modifyData = Just <| Every.Update <| \ms ->
                           case ms of
                             Nothing ->
                               { kickoffCount = 1
                               }
                             Just ks ->
                               { kickoffCount = ks.kickoffCount + 1
                               }
                       }
      )
```
