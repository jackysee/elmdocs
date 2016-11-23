# Time Machine for Elm

It's like a Delorean for your state!

## What is it?

`elm-time-machine` is a library for the [Elm Programming Language](http://elm-lang.org) that tracks the history of your application's state, and contains a pointer letting you, in essence, travel backward or forward to some point in that state's timeline. It was written for the undo/redo functionality for [Flittal](http://flittal.com), a keyboard-driven flow charting tool, but should be general enough for anyone to use.

## Usage

Install with:

```
elm-package install joefiorini/elm-time-machine
```

Add a property to your state to hold the history:

```elm
type alias AppState =
  { contacts  : List Contact
  , history : TimeMachine.History (List Contact)
  }
```

Initialize it in your default state:

```elm
defaultState =
  { contacts = []
  , history = TimeMachine.initialize []
  }
```

And then record entries whenever your state changes:

```elm
step update state =
  case update of
    AddContact contact ->
      let contacts' = contact :: state.contacts
      in
        { state | contacts <- contacts'
                , history <- TimeMachine.record contacts'
        }
```

To undo call `travelBackward`:

```elm
step update state =
  case update of
    Undo ->
      let history' = TimeMachine.travelBackward state.history
      in
        case history'.current of
          Just contacts' ->
            { state | contacts <- contacts'
                    , history <- history'
            }
          Nothing -> state
```

To redo call `travelForward`:

```elm
step update state =
  case update of
    Undo ->
      let history' = TimeMachine.travelForward state.history
      in
        case history'.current of
          Just contacts' ->
            { state | contacts <- contacts'
                    , history <- history'
            }
          Nothing -> state
```

Both of these functions will take you one step in either direction. Rather than returning the item, they return a new history record with the item in `current`. In the event that you travel all the way back to the beginning of time, you will get `Nothing`.

For more, see [the Elm package API docs](http://package.elm-lang.org/packages/joefiorini/elm-time-machine/1.0.0).

## Contributing

Write a test, run it, repeat. Run tests with:

```
cd test
make test
```

To automatically run tests when files change, first install daemontools and entr. On a Mac:

```
brew install daemontools
brew install entr
```

Neither of these tools will impact your development environment until you run them.

To start watching run:

```
cd test
supervise .
```

Feel free to open an issue or pull request if anything doesn't make sense.
