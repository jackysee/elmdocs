# URL Parser

This library helps you turn URLs into nicely structured data.

This is a fork of the excellent [evancz/url-parser][] library, with the dependency on `elm-lang/navigation` removed. This avoids pulling in browser specific stuff like `dom`, 'html', 'navigation', and 'virtual-dom'. It is meant for use with non-browser based applications, such as [ktonon/elm-serverless][], but it can still be used with SPAs.

The only difference is `parsePath` and `parseHash` (which depend on the `Location` type defined in the `Navigation` library) are replaced by a single `parse` function.

## Examples

Here is a simplified REPL session showing a parser in action:

```elm
> import Dict exposing (empty)
> import UrlParser exposing ((</>), s, int, string, parse)

> parse (s "blog" </> int) "#blog/42" empty
Just 42

> parse (s "blog" </> int) "#/blog/13" empty
Just 13

> parse (s "blog" </> int) "#/blog/hello" empty
Nothing

> parse (s "search" </> string) "#search/dogs" empty
Just "dogs"

> parse (s "search" </> string) "#/search/13" empty
Just "13"

> parse (s "search" </> string) "#/search" empty
Nothing
```

Normally you have to put many of these parsers to handle all possible pages though! The following parser works on URLs like `/blog/42` and `/search/badger`:

```elm
import Dict exposing (empty)
import UrlParser exposing (Parser, (</>), s, int, string, map, oneOf, parse)

type Route = Blog Int | Search String

route : Parser (Route -> a) a
route =
  oneOf
    [ map Blog (s "blog" </> int)
    , map Search (s "search" </> string)
    ]

-- parse route "#/blog/58" empty    == Just (Blog 58)
-- parse route "#/search/cat" empty == Just (Search "cat")
-- parse route "#/search/31" empty  == Just (Search "31")
-- parse route "#/blog/cat" empty   == Nothing
-- parse route "#/blog" empty       == Nothing
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
