# Elm RFC5988 Parser

A (presently woefully incomplete) parser for [the upcoming RFC5988 replacement
draft](https://mnot.github.io/I-D/rfc5988bis/), written in Elm using
[elm-combine](http://github.com/Bogdanp/elm-combine) for
[DailyDrip](http://www.dailydrip.com).

## Example

There are some examples in the test suite, but here's one:

```elm
Expect.equal
  (parse rfc5988 "<http://urbit.org>; rel=\"start\"")
  ( Ok { context = "", target = "http://urbit.org", relationType = "start", targetAttributes = Dict.empty }
  , { input = "", position = 31 }
  )
```

## Todo

There's a **lot** of stuff left to do here.  Here's an
almost-certainly-incomplete list:

- [ ] Handle context at all (I think we want to just partially-apply one when
  parsing in the first place?)
- [ ] Determine whether it makes any sense at all for `relationType` to have its
  own field.
- [ ] Determine if we should add other similar fields, if that was reasonable.
- [ ] There are almost certainly some fields that should have a `Maybe` type
  signature.
- [ ] If there are two `rel` parameters, there's a very specific callout in the
  spec that we're supposed to follow that we almost certainly aren't (but they
  aren't supposed to have them either!)
