# RFC2822 Datetime

<img src="https://ci.appveyor.com/api/projects/status/github/stil4m/rfc2822-datetime?branch=master&retina=true" height="24">

Elm package that supports parsing datetime strings specified in the [RFC2822](https://tools.ietf.org/html/rfc2822).

```
module Main exposing (..)

import Rfc2822Datetime exposing (Datetime)

parsedDate : Result String Datetime
parsedDate =
    Rfc2822Datetime.parse "Mon, 06 Mar 2017 21:22:23 +0000"
```

Please [report](https://github.com/stil4m/rfc2822-datetime/issues) issues if you encounter any and feature requests.
