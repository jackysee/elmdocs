# Human Readable File Sizes in Elm [![Travis build Status](https://travis-ci.org/basti1302/elm-human-readable-filesize.svg?branch=master)](http://travis-ci.org/basti1302/elm-human-readable-filesize)

This library converts a file size in bytes into a human readable string.

Examples:

```
format 1234 == "1.23 kB"
format 238674052 == "238.67 MB"
format 543 == "543 B"
```

See [package documentation](http://package.elm-lang.org/packages/basti1302/elm-human-readable-filesize/latest/Filesize) for more details and customization options.

## Releases

* 1.1.0 - 2017-06-01: Expose `formatBase2` as a convenience function (alias for `formatWith { defaultSettings | units = Base2 }`.
* 1.0.1 - 2017-06-01: Use [myrho/elm-round](http://package.elm-lang.org/packages/myrho/elm-round/latest/) internally for rounding.
* 1.0.0 - 2017-03-08: Initial release

