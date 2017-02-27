# Keyboard Extra

### Description
Add simple and complex hotkeys to your application with a single case
statement.

Forked from: https://github.com/amilner42/keyboard-extra keeping the strongly
typed Key union type and rewriting the entire public API to allow the use of
pattern matching to express key combos.

Some kinds of keycombinations you can dispatch against:

- Press and release A and B while Shift is held
- Press and release J while Shift and Tab are held down
- Press and release keys in a specific order A B C but not A C B

Example:
```elm
case keyboardExtraModel.keyState of
  {- first element matches the keys currently held down, second element matches
  the keys that have recently released
  -}
  ( [ Shift ], [CharA, CharB] ) ->
      doSomething model

  {- Matches both Tab+Shift and Shift+Tab event ordering because library sorts
  the list by KeyCode after assuming you probably don't care about ordering
  -}
  ( [ Tab, Shift ], [CharJ] ) ->
    handleSomeBizareHotkeyGroup model

  {- Handling a specific key ordering takes a little more work because that is
  not the common case
  -}
  ( _ , [CharA, CharB, CharC] ) ->
    case keyboardExtraModel.releaseHistory ->
      [ CharA, CharB, CharC ] ->
        doOrderMattersThing model

      _ -> model

  _ -> model
```

Keeps track of the current keys being pressed, but also helps fight bugs
where `onKeyUp` does not always get triggered for all the keys pressed down,
this only keeps track of the last 3 keys. This way if a key gets added for
`onKeyDown` and doesn't get removed for `onKeyUp`, it can be cleared by pressing
a few different more keys.

[Stack Overflow Post Talking about missing `onKeyUp` event](http://stackoverflow.com/questions/27380018/when-cmd-key-is-kept-pressed-keyup-is-not-triggered-for-any-other-key)

This library is not designed for games, it's designed for apps where you want
to add hotkeys to trigger certain events. This version supports keys combos
with multiple keys held down simultaneous and multiple keys released.

### Usage

Add it to your Model:

```elm
type alias Model =
    { keysDown : Keyboard.Extra.Model
    -- ...
    }
```

Add it to your init:

```elm
init =
    { keysDown = Keyboard.Extra.init
    -- ...
    }

-- If your init also expects a Cmd then pair it with Cmd.none.
```

Add it to your messages:

```elm
type Msg =
    KeyboardExtraMsg Keyboard.Extra.Msg
    -- ...
```

Add it to your update.

The `List` of pressed `Keys` will be sorted by the `Keyboard.Extra.update` to
avoid having to pattern match all possible orders of key presses. The downside
is you must manually sort the list of Keys in your pattern matching by KeyCode
value.

```elm
update msg model =
  case msg of
    KeyboardExtraMsg keyMsg ->
      updateKeysDown keyMsg model

  -- ..

updateKeysDown : Keyboard.Extra.Msg -> Model -> Model
updateKeysDown keyMsg model =
  let
    newKeysDown = Keyboard.Extra.update keyMsg model.keysDown
    -- dont forget to update the Keyboard.Extra.Model
    newModel = { model | keysDown = newKeysDown }
  in
    case newKeysDown.keyState of
      -- Tab has KeyCode of 9 and Shift has KeyCode of 16.
      ( [ Tab, Shift ], [keyPressed] ) ->
        -- handle all hotkeys groups that require tab and shift to be held
        case keyPressed of
          CharC ->
            copySelection newModel

          CharV ->
            pasteSelection newModel

          CharX ->
            cutSelection newModel

      ( [ Meta, Control, Plus ], [] ) ->
        handleSomeBizareHotkeyGroup newModel

      _ ->
        newModel
```

And lastly, hook up your subscriptions:

```elm
subscriptions model =
    Sub.batch
       [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
       -- ...
       ]
```

### Common Pitfalls

Let's say you add a hotkey for a double-key, like shift-tab, and you want the
user to not only be able to click shift-tab multiple times, but click shift-tab
and hold on to shift again but keep clicking tab. This is relatively standard
behaviour and someone is _likely_ to do this over letting go of the shift every
time. Let's take a look at what happens:

1. Event: keydown Shift -> Model: { keyState = ( [ Shift ], Nothing) ... }
2. Event: keydown Tab   -> Model: { keyState = ( [ Tab, Shift ], Nothing) ... }
3. Event: keyup   Tab   -> Model: { keyState = ( [ Shift ], Just Tab) ... }
4. Event: keydown Tab   -> Model: { keyState = ( [ Tab, Shift ], Nothing) ... }
5. Event: keyup   Tab   -> Model: { keyState = ( [ Tab, Shift ], Just Tab) ... }
6. Event: keydown Tab   -> Model: { keyState = ( [ Tab, Shift ], Nothing) ... }

