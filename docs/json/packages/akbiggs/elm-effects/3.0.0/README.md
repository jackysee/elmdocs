This package contains several useful functions for operating on pairs
of a value and a list of side-effects. Side-effects do not have to be external
Elm events - they can be internal app events, such as a message indicating that
the score of your game should increase, or that you want to navigate the app
back to the home page.

This library can be used in combination with `Cmd`s -- it operates
on a generic `(a, List b)` pair, which means that you can use it on a
`(Model, List (Cmd Msg))` pair and then batch the commands together later using
`Effects.toCmd`. However, it is also useful in situations where `Cmd`s cannot be used,
such as returning effects that are handled by other components.
