# `elm-unwrap`
This library provides quick functions for uunwrapping value wrapper
types such as Maybe and Result types. I have found myself rewriting this time
and time again, so I thought to separate it out into a package.

Only use these if the program SHOULD crash in the case of the value not being
present.

# Installation
```bash
elm package install callumjhays/elm-unwrap
```

# Functions

## `Unwrap.maybe : Maybe val -> val`

Forcibly unwraps a maybe. Crash the program when it is Nothing.

```elm
Unwrap.maybe (Just 42) == 42
Unwrap.maybe Nothing -- CRASHES
```

## `Unwrap.result : Result err val -> val`

Forcibly unwraps a result. Crash the program when it is Err.

```elm
Unwrap.result (Ok 42) == 42
Unwrap.result (Err "Should never happen") -- CRASHES
```