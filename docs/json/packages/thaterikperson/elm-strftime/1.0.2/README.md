# Strftime

An (incomplete) implementation of the strftime format based on rules
from [http://strftime.org](http://strftime.org).

## Usage

```elm
import Strftime exposing (format)


format "%d %b %y" (Date.fromTime 1499000000000) == "02 Jul 17"

format "%B %d %Y, %-I:%M" (Date.fromTime 1490000000000) == "March 20 2017, 4:53"
```
