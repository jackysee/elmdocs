
Compares strings to produce change lists.  `diffChars` and `diffLines` are provided.

The currently-implemented algorithm is the [Hunt-McIlroy algorithm](http://en.wikipedia.org/wiki/Hunt%E2%80%93McIlroy_algorithm).

Pull requests optimizing the existing algorithm are welcome.

Pull requests implementing alternative diff algorithms (notably, the [Patience algorithm](http://alfedenzo.livejournal.com/170301.html)) are also welcome.

```elm
import Diff (..)

diffChars "abc" "aBcd"
  -- [ NoChange "a", Changed "b" "B", NoChange "c", Added "d" ]


original = """Brian
Sohie
Oscar
Stella
Takis
"""

changed = """BRIAN
Stella
Frosty
Takis
"""

diffLines original changed
  -- [ Changed "Brian\nSohie\nOscar\n" "BRIAN\n"
  -- , NoChange "Stella\n"
  -- , Added "Frosty\n"
  -- , NoChange "Takis\n"
  -- ]
```

**This package should still be considered unstable:** while the returned list of changes will always be correct, the specific the list of changes and the way the changes are grouped/combined, as well as the performance characteristics of the diff algorithm may change in future releases of this package.
