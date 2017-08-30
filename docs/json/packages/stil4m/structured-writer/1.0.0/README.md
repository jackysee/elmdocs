![Project Badge](https://ci.appveyor.com/api/projects/status/github/stil4m/structured-writer?svg=true&passingText=master%20-%20OK)

--------------------------------------------------------------------------------

# Structured Writer

Allows you to create strings for certain structures

```
import StructuredWriter exposing (..)


write (parensComma False [string "a", string "b", string "c"] ) == "(a, b, c)"
write (indent 2 (breaked [string "a", string "b"])) == "  a\n  b"
```
