# *oprocesso* - a combinator-based elm framework

> Josef K. foi certamente vítima de alguma calúnia, pois, numa bela manhã, sem ter feito nada de mal, foi detido.

## Disclaimer

This framework is at the moment at a state of a bare *proof of concept*. The chances are high that it will suffer significant changes. It might even be the case that the key idea is flawed, I don't know yet.

The library itself only depends on `elm-lang/core`. The example(s) added more constraints. Sorry, did not mess with these for now.

## Dive Into

This `README` is meant to be an overall overview; it gives the general concept, then the semantics and eventually the implementation details. I'll keep it updated as I go along.
Also, I tried to give examples within the documentation of the library itself. You might have a look (especially into `src\Oprocesso.elm`).

Besides I'll keep adding examples to `examples/` -- if you have some concept of the general model-view-controller style in `elm`, you should get the idea just by starring long enough into `examples/JsonEcho.elm`.

## Basic Concept

The framework *oprocesso* is meant to give a way to structure an elm app; especially it manages all the signal processing; all what is left is writing the meat of the app.

The concept is based on the strict model-view-controller framework which `elm` suggests, at least when building HTML apps (see [the TodoMVC example](https://github.com/evancz/elm-todomvc>)), but it shifts it in an important way: instead of defining an `Action` type, which inhabitant's get send to the action mailbox whenever there is some action happening, one defines `Oprocesso.Action`s which can be thought of as functions of type `Model -> Model` and which get instead send to the action mailbox.

So, instead of

```{.elm}
data Action = NoAction | Typing String | ...

update : Action -> Model -> Model
update act m =
  case act of
    NoAction   -> m
    Typing s   -> { m | typed <- s }
    ...
{-
  ...
-}  

inputfield : String -> Html
inputfield inp =
  input [ value inp
        , on "input" (Json.Decode.map Typing targetValue)
                     (Signal.message actionbox.address) ] []

{- ... -}
```

with *oprocesso* one can write:

```{.elm}
typing : String -> (Model -> Model)
typing s =
  \m -> { m | typed <- s }

{-
  ...
-}  

inputfield : String -> Html
inputfield inp =
  input [ value inp
        , on "input" (Json.Decode.map (pureParam typing) targetValue)
                     (Signal.message actionbox.address) ] []
```

One might say it is just a *shift* from a first order `Action` to a second order `Model -> Model` which gets foldp'ed instead. This shift (which was actually brought up by Max Goldstein in his [answer](https://groups.google.com/forum/#!topic/elm-discuss/RFLjOxQp1PA) to a question of mine), although, leads to two points which I consider as an improvement (from now on, "Actions" are meant to be `Oprocesso.Action`s):

  1. Actions are based upon functions; those functions can be combined in a natural way to form new functions, so starting with small, obvious actions, one can build up more complex ones -- which stay therefore obvious. (For those who had the time and pleasure to build their own [monadic] parser combinators [in Haskell], the shift described above might already have rang a bell. Although, `Oprocesso.Action`s are not in the same kind monadic as parser combinators are -- [they could, but they don't need to](#actionNOTmonadic).)
  2. Actions can be asynchronous; this is due to the fact, that actions can be made out of `Task`s.

## Framework's Entities

### Actions and Modifiers

In the center there is an `Oprocesso.Action x Model`; it represents an action on the model, i.e. something that describes how to map a certain model onto another. There are two differnt sorts of actions:

  - **pure actions**: these just change the model, so they can be thought of as functions of type `Model -> Model`
  - **asynchronous actions**: these build up a *pure action* on the current model which gets executed asynchronously. They can be thought of functions of type `Model -> Task x (Model -> Model)`.

Since *pure actions* are almost just functions of type `Model -> Model` they have a close relationship to such functions. Usually *pure actions* are made out of `Model -> Model` by lifting them with `pure` and `pureParam`:

```{.elm}
addEntry : Oprocesso.Modifier Model
addEntry =
  \m -> { m | entries <- m.entries ++ [m.typed] }

setInput : String -> Oprocesso.Modifier Model
setInput s =
  \m -> { m | typed <- s }

{-
  Now we have:

    pure addEntry : Oprocesso.Action x Model

  and

    pureParam setInput : String -> Oprocesso.Action x Model
-}
```

These actions are called *pure* since they do not involve any IO, any outside computation (that may fail). So, they are pure in a functional sense.

On the other hand, *asynchronous actions*  involving outside computation. They may send a http request, doing some database communicating etc. Hence they are related to `Task`s of a certain kind, such, which are modifying the model, i.e. of type `Task error (model -> model)`. These tasks are used to make up *asynchronous actions* with `async` and `asyncOn`:

```{.elm}
echoJson : Task String (Model -> Model)
echoJson =
  let vvDecoder_ =
        object2 (,)
          ("v1" := string)
          ("v2" := string)
  in Task.mapError toString (Http.get vvDecoder_ ("http://echo.jsontest.com/v1/Hello/v2/World"))
     `Task.andThen` \(s1, s2) -> Task.succeed <| addEntry ("Echoed: " ++ s1 ++ "/" ++ s2)

requestJson : String -> Task String (Model -> Model)
requestJson typd =
  let vvDecoder_ =
        object2 (,)
          ("v1" := string)
          ("v2" := string)
  in Task.mapError toString (Http.get vvDecoder_ ("http://echo.jsontest.com/" ++ typd))
     `Task.andThen` \(s1, s2) -> Task.succeed <| addEntry ("Echoed: " ++ s1 ++ "/" ++ s2)

{-
  Hence,

    async echoJson : Oprocesso.Action Model String

  and

    requestJson `asyncOn` .typed : Oprocesso.Action Model String

  where

    .typed : Model -> String
-}
```

So the function `pure` has its dual in `async`, where `asyncOn` is connected to `pureParam` in some sense.

## Flow Control

### Flow Control Operators

Okay, so I've explained how to make up actions from simple building blocks; these so gained actions are somewhat overt. Also, *oprocesso* gives one the possibility to make up more complex *actions* by combining *actions* themselves.

There are three flow control operators:

  1. `thenDo : Action error model -> Action error model -> Action error model` (or `(>>-)` before the error handling and `(-<<)` after) which just glues two actions together such that they get executed one right after the other. That means: if the first action is asynchronous the second one will wait until the first returns and will only get invoked, if the first one succeeded.
  2. `next : Action error model -> Action error model -> Action error model` (or `(=>>)`), which is the asynchronous combinator. It invokes the first action and right after that invokes the second one.
  3. `onfail : Action error model -> (error -> Action x model) -> Action x model` (or `(!<<)`) which is the `catch` combinator. It provides an error handler as its second argument which gets run if the first action is an asynchronous action which failed. Otherwise it does not alter the action. Considering its type,  `onfail` is meant to make the `error` type meaningless.

The idea is to define the needed tasks and `Model -> Model` inhabitants and then lift and glue them together into complex *actions*:

```{.elm}

  {-| 'makeRequest'
  - disables the input box
  - starts an asynchronous request based on the current input
    !<< prints out error if happened
  - enables the input box
  also:
  - adds what was typed
  - empties the input box right after. -}

  makeRequest : Action x Model
  makeRequest =
                blockInput
            >>- requestJson `asyncOn` .typed
                !<< \s -> pureParam addEntry <| "Error: " ++ s
            -<< unblockInput
     =>>
                pure addTyped
            >>- pureParam setInput ""

  {- ... used in the following way:

      onEnter (.address Oprocesso.actionbox) makeRequest

  -}
```

As a good practice, the top-level actions you want to invoke by UI events should be of type `Action x Model`, so that any non-caught exception will raise a type error.

## Setup *oprocesso*

First, you need some imports:

```{.elm}
import  Oprocesso
import  Oprocesso.Types         as OT
import  Oprocesso.EDSL          exposing (..)
```

where I propose to expose the lifts from `Oprocesso`, i.e. `import Oprocesso exposing (async, asyncOn, task, pure, pureParam)`.

Next, there is one port you need to run, which runs the tasks and calls the actions by feeding them back into the `actionbox`,

```{.elm}
port asyncrunner : Signal (Task x ())
port asyncrunner = Oprocesso.ioport initmodel

```

where `initmodel` is the initial model.

At last, there is `Oprocesso.hook : model -> Signal model`, you can use for what ever you want. Mainly:

```{.elm}
main : Signal Html
main = Signal.map view (Oprocesso.hook initmodel)
```

Here, the parameter to `Oprocesso.hook` is -- again, ... it's a flaw -- the initial model. And **it has to be the same you've used on `Oprocesso.ioport`**.


## Inner Concepts

### Actions as Lists of Operations

### Box-Port Cycles

### <a name="actionNOTmonadic"></a>Actions aren't Monadic

## Future Plans

Some questions I want to consider so far:

  - What about more complex apps, involving `fpsWhen` ?
