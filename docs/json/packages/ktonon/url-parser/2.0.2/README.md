# URL Parser

This library helps you turn URLs into nicely structured data.

This is a fork of the excellent [evancz/url-parser][] library, with the dependency on `elm-lang/navigation` removed. This avoids pulling in browser specific stuff like `dom`, 'html', 'navigation', and 'virtual-dom'. It is meant for use with non-browser based applications, such as [ktonon/elm-serverless][], but it can still be used with SPAs.

There are two differences from `evancz/url-parser`:

1. Removed `elm-lang/navigation` from the dependencies
  * `parsePath` and `parseHash` still work with `Navigation.Location` because a type equivalent alias is defined for `Location` internally.
2. Added `parseString : Parser (a -> a) a -> String -> Maybe a`
  * use this to parse paths directly, without the need for a `Location` record.

## Examples

Here is a simplified REPL session showing a parser in action:

```elm
> import UrlParser exposing ((</>), s, int, string, parse)

> parseString (s "blog" </> int) "#blog/42"
Just 42

> parseString (s "blog" </> int) "#/blog/13"
Just 13

> parseString (s "blog" </> int) "#/blog/hello"
Nothing

> parseString (s "search" </> string) "#search/dogs"
Just "dogs"

> parseString (s "search" </> string) "#/search/13"
Just "13"

> parseString (s "search" </> string) "#/search"
Nothing
```

Normally you have to put many of these parsers to handle all possible pages though! The following parser works on URLs like `/blog/42` and `/search/badger`:

```elm
import UrlParser exposing (Parser, (</>), s, int, string, map, oneOf, parse)

type Route = Blog Int | Search String

route : Parser (Route -> a) a
route =
  oneOf
    [ map Blog (s "blog" </> int)
    , map Search (s "search" </> string)
    ]

-- parseString route "#/blog/58"    == Just (Blog 58)
-- parseString route "#/search/cat" == Just (Search "cat")
-- parseString route "#/search/31"  == Just (Search "31")
-- parseString route "#/blog/cat"   == Nothing
-- parseString route "#/blog"       == Nothing
```

Notice that we are turning URLs into nice [union types](https://guide.elm-lang.org/types/union_types.html), so we can use `case` expressions to work with them in a nice way.

## Testing

```
npm install
npm test
```

## Background

> I first saw this general idea in Chris Done&rsquo;s [formatting][] library. Based on that, Noah and I outlined the API you see in this library. Noah then found Rudi Grinberg&rsquo;s [post][] about type safe routing in OCaml. It was exactly what we were going for. We had even used the names `s` and `(</>)` in our draft API! In the end, we ended up using the &ldquo;final encoding&rdquo; of the EDSL that had been left as an exercise for the reader. Very fun to work through!

-- [evancz](https://github.com/evancz)

[evancz/url-parser]:https://github.com/evancz/url-parser
[formatting]: http://chrisdone.com/posts/formatting
[ktonon/elm-serverless]:https://github.com/ktonon/elm-serverless
[post]: http://rgrinberg.com/posts/primitive-type-safe-routing/
