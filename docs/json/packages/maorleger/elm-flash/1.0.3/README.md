# elm-flash

A small library to manage showing and hiding flash messages. The client is in control of the length of time and the view layer. The library simply wraps some state and controls showing and hiding events.

## As an example:

```
-- Initialize our flash message
init =
  ({
    ...
    flash = Flash.none
    ...
  }, Cmd.none)


-- Set flash message for 2 seconds
update =
  case msg of
    ...
    SetFlash ->
      let
        ( message, cmd) = 
          Flash.setFlash RemoveFlash 2000 "My flash message for 2 seconds"
      in
        ({ model | flash = message }, cmd)

    RemoveFlash ->
      ({ model | flash = Flash.none }, Cmd.none)
  
  ...

-- Use it in your view
view =
  ...
  ++ case (Flash.getMessage model.flash) of
        Nothing ->
          []

        Just message ->
          [ text <| "Flash: " ++ message ]
```
