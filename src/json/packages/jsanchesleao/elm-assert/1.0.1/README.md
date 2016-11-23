# Assert

Tiny x-unit like testing library.

```elm
import Assert exposing (report, suite, test)

main =
  report "My App" 
    [ suite "Testing Strings" 
      [ test "values are equal" "ok" "ok"
      , test "values are not equal" "bla" "ble"
      , test "records" {a = 1} {a = 1}
      , test "records failing" {a = 1} {a = 2}
      ]
    ]
```
This will generate a report HTML like the following:

![Assert Report](./example/assert.png)
