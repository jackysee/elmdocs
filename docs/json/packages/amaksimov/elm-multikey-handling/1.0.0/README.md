# elm-multikey-handling

Extra helpers for handling multiple key combinations on html nodes.

## Usage

Just add the attribute to the html node

```elm
  div [ class "input-wrapper" ]
      [ input [ type_ "text"
              , id "new-item-input"
              , placeholder "Type item name"
              , onBlur (ItemInput Nothing)
              , onInput (\x -> ItemInput (Just x))
              , defaultKeyHandler
                  |> whenEnter (CreateItemClick boardName)
                  |> whenEscape (Iteam Nothing)
                  |> onKeydown
              ]
              [ text itemName ]
```

You can use `whenKeydown` when dealing with buttons without predefined decoders.

```elm
  defaultKeyHandler
    |> whenKeydown 13 (CreateItemClick boardName)
    |> onKeydown
```
