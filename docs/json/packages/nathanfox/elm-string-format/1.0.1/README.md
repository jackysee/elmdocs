# String format for Elm

This is a very simple implementation of format strings for Elm.

## Usage

There is a different format function based on the number of place holders in the format string up to 9. So format1, format2, ..., format9.

To substitute 1 value
```Elm
format1 "Value: {1}" 1
-- Will result in the string "Value: 1"
```

More than one value is passed using a tuple.
```Elm
let
  x = 1
  y = "2nd"
  z = 3.3
in
  format3 "Val 1: {1}, Val 2: {2}, Val 3: {3}" (x, y, z)
-- Will result in the string "Val 1: 1, Val 2: 2nd, Val 3: 3.3"
```
Underneath toString is being called for the values. Please view the tests for more examples.
