# elm-console-log

```elm
import ConsoleLog exposing (log)

List.map (\x -> (log "C" x)) [1, 2, 3]
-- logs 1, 2, 3 and returns them
```

This module provides `ConsoleLog.log`, which takes what it's given, converts it to string and logs it to the console before then returning the original item. This makes it perfect for quickly dropping into your code to debug the value.
