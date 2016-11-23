## romkan-elm

Romkan is a library to convert between Japanese Romaji and Kana.

This is an Elm port
of [the Haskell port](https://github.com/karlvoigtland/romkan-hs)
of [the Python port](http://www.soimort.org/python-romkan)
of [Ruby/Romkan](http://0xcc.net/ruby-romkan).

### Usage

```sh
$ elm package install spect88/romkan-hs
```

```elm
import Romkan

Romkan.toHiragana "kekkou" -- => "けっこう" : String
```

### Development

To run the tests:

```sh
$ npm install elm-test -g
$ elm test
```

To test documentation:

```sh
$ elm make --docs=documentation.json
```

Then upload generated `documentation.json` file to
[documentation preview](http://package.elm-lang.org/help/docs-preview).
