# elm-param-parsing-2

Ripped off from [jessitron's library](https://github.com/jessitron/elm-param-parsing) -
there were just a few subtleties I thought were left out.

## Query String Parsing

So this module parses URI query strings - specifically strings
that begin with the character `?`, and are a `&`-separated list
of substrings, which themselves may be split via a `=`. The string
in question should also be ASCII (check me on this), encoded as a
`x-www-urlencoded` MIME type.

To parse such a string, just feed it into `parseQuery`:

```elm
parseQuery "?foo=bar&baz&qux=1"
> [("foo", Just "bar"), ("baz", Nothing), ("qux", Just "1")]
```

I believe the type `List (String, Maybe String)` is more precise
than a `Dict` for a number of reasons, which I detail in the docs.
Happy hacking!
