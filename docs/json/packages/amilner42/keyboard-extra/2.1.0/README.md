# Keyboard Extra

Forked from: https://github.com/ohanhi/keyboard-extra.

### Description

Intended to keep track of the current keys being pressed, but to avoid bugs
where `onKeyUp` does not always get triggered for all the keys pressed down,
this only keeps track of the last 3 keys. This way if a key gets added for
`onKeyDown` and doesn't get removed for `onKeyUp`, it gets cleared pretty
quickly anyway in just few key-presses.

[Stack Overflow Post Talking about missing `onKeyUp` event](http://stackoverflow.com/questions/27380018/when-cmd-key-is-kept-pressed-keyup-is-not-triggered-for-any-other-key)

This library is not designed for games, it's designed for apps where you want
to add hotkeys to trigger certain events.

If you have hotkeys that are longer than 3-keys, then this library will not
work for you, if you have that use-case make an issue and I can _possibly_
change the code up a bit.

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

```elm
case msg of
    KeyboardExtraMsg keyMsg ->
        let
            newKeysDown =
                Keyboard.Extra.Update keyMsg model.keysDown
        in
            -- If you want to react to key-presses, call a function here instead
            -- of just updating the model (you should still update the model).
            ({ model | keysDown = newKeysDown }, Cmd.none)
    -- ...
```

And lastly, hook up your subscriptions:

```elm
subscriptions model =
    Sub.batch
       [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
       -- ...
       ]
```
