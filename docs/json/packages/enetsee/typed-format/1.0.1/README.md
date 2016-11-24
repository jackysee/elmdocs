# Typed Format

This library helps you turn data into nicely formatted strings
in a type-safe manner.

The API deliberately mirrors [url-parser](https://github.com/evancz/url-parser)
which is based on the same idea (see references).

## Examples

Here is a formatter that, when applied with 'sprintf', will accept a string output the string `hello [X]!`

```elm
hello : Format a (String -> a)
hello =
    s "hello " <++> string <++> s "!"
```

You can combined formatters using `<++>` to get more complex formatters. For example:

```elm
doubleHello : Format a (String -> String -> a)
doubleHello =
    hello <++> hello
```

and

```
myMessage : Format a (Char -> Char -> a)
myMessage =
    s "Elm gets me from " <++> char <++> s " to " <++> char
```

See the [examples](https://github.com/enetsee/typed-format/tree/master/examples) for more examples.

## Installation
```
elm package install enetsee/typed-format
```

## References

The library is based on the final representation of the `Printer` type from
Oleg Kiselyov's [Formatted Printer Parsers](http://okmij.org/ftp/tagless-final/course/PrintScanF.hs)

The [url-parser](https://github.com/evancz/url-parser) library is based on the
corresponding `Scanner` type.
