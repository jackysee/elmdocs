# elm-threading

A simple method for managing asynchronous ports that may be flooded
with invocations:

```elm
-- a simple hashing module
module Hash exposing (..)

import Threading
import Task


type alias Hashed = String

port makeHash : String -> Cmd a
port madeHash : (Hashed -> a) -> Sub a


type Msg a
  = ThreadingMsg (Threading.Msg String Hashed Msg)
  | HashThis String (Hashed -> Cmd a)

type alias Model a =
  { threading : Threading.Model Hashed (Msg a)
  }
  
init : (Model a, Cmd (Msg a))
init = ({ threading = Threading.init }, Cmd.none )

update : Msg a -> Model a -> (Model a, Cmd a)
update action model =
  case action of
    ThreadingMsg a ->
      let (newThreading, threadingCmd) =
            Threading.update makeHash a model.threading
      in  ( { model | threading = newThreading }
          , Cmd.map (\r -> case r of
                             Err a -> ThreadingMsg a
                             Ok a  -> a) threadingCmd
          )
    HashThis toHash whenComplete ->
      ( model
      , Task.perform Debug.crash ThreadingMsg
          <| Task.succeed <| Threading.Call toHash whenComplete
      )

subscriptions : Sub (Msg a)
subscriptions = Sub.map ThreadingMsg
             <| Threading.subscriptions madeHash
```

Bam! Continuation-style passing for javascript ports. Note that
we leave `a` here - we still need the user of this module to pass
their "handler" for when the port finishes, but that's okay by
my book. If you have serious complaints, you should use sticks
and rocks instead of your computer.

> It may be easier to use
> [Shmookey's Cmd.Extra](http://package.elm-lang.org/packages/shmookey/cmd-extra/1.0.0/Cmd-Extra)
> instead of constantly doing `Task.perform Debug.crash identity << Task.succeed`
> all over teh place

```js
app.ports.makeHash.subscribe(function(threadedInput) {
  var threadedOutput = {
    threadId = threadedInput.threadId,
    payload  = hash(threadedInput.payload) // something async or w/e
  };
  app.ports.madeHash.send(threadedOutput);
});
```
