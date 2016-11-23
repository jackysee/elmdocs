# Elm Timer

A simple **digital clock** that can either count to a future date or go backwards (countdown).

## Getting started

**No dependencies** are required. Just grab the package and you're good to go.

    elm package install simonewebdesign/elm-timer

A couple [examples](https://github.com/simonewebdesign/elm-timer/tree/master/examples) are provided: [simple](https://github.com/simonewebdesign/elm-timer/tree/master/examples/simple) and [startapp](https://github.com/simonewebdesign/elm-timer/tree/master/examples/countdown). The former doesn't use [StartApp](https://github.com/evancz/start-app); the latter does.

You can either have a look at the examples or read below to get started.

---

### Wire it up with `StartApp`

First of all, import the module:

``` elm
import Timer
```

Then add it to your model:

``` elm
type alias Model =
  { timer : Timer.Model }
```

Provide an initial value for it:

``` elm
initialModel =
  { timer = Timer.init }
```

Define an action:

``` elm
type Action
  = NoOp
  | TimerAction Timer.Action
```

Update your `update`:

``` elm
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    TimerAction subAction ->
      ( { model | timer = Timer.update subAction model.timer }
      , Effects.none
      )

    ...
```

Add it to your `view`:

``` elm
view address model =
  text (Timer.view model.timer)
```

And feed it to `StartApp`:

``` elm
app =
  StartApp.start
    { init = ( initialModel, Effects.none )
    , update = update
    , view = view
    , inputs = [ Signal.map TimerAction Timer.tick ]
    }
```

If everything's wired up correctly, you should be able to see a timer in your app.


### A backwards clock (aka countdown)

If you want to reverse the clock, just use `Timer.countdown` instead of `Timer.tick`.
For example if you're using `StartApp` your configuration will look like:

``` elm
app =
  StartApp.start
    { inputs = [ Signal.map TimerAction Timer.countdown ]
    , ...
    }
```


### Extras

There are a couple of things that are being used internally, but I figured they might be useful.

#### `clock`

The `clock` function is a `Signal Int` that receives a new value every second.

#### `addLeadingZero`

Another function that just adds a leading zero to a number *only if* it's just a single digit.
The signature is `addLeadingZero : number -> String`.
