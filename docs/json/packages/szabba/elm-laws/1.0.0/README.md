This module provides a saner DSL for Elm Check.

Property testing is great, there's no arguing against it. With Elm Check's DSL
we can write claims about our code like this:

```elm
import Check exposing (..)
import Check.Producer exposing (list, int)

listSortIsIdempotent =
    claim
        "List.sort is idempotent"
    `that`
        (List.sort >> List.sort)
    `is`
        List.sort
    `for`
          (list int)
```

That looks pretty nice. However, the documentation of the
[`Check`](http://package.elm-lang.org/packages/elm-community/elm-check/latest/Check)
module itself says:

> _Warning: The DSL follows a very strict format. Deviating from this format
will yield potentially unintelligible type errors. The following functions have
horrendous type signatures and you are better off ignoring them._

Now, Elm Check was made by smart people. The error messages can be as bad as
they say they can be.

That's where `Laws` comes in. What it tries to do is:

* reuse the machinery of Elm Check -- it's great, and there's no point to
  reinvent it
* provide an API that gives better type errors
* provide an API that has more comprehensible types (so you can easily see how
  different things fit together)

So how does that previous claim look with `Laws`? See for yourself:

```elm
import Laws exposing (claim, equivalent)

listSortIsIdempotent =
    claim "List.sort is idempotent"
        (List.sort `equivalent` (List.sort >> List.sort))
        (list int)
```

Have any thought about this? Think it's a bad idea? You know how to improve it?
Feel free to chat me up at the [Elm Slack](https://elmlang.slack.com/)!

# License

`elm-laws` is distributed under the Mozilla Public License 2.0 (see `LICENSE`).