# elm-md5

Compute MD5 message digests in Elm.

## Quick Start

This library exposes just one function, `hex`, which takes a `String` input and returns the 128-bit MD5
digest as a `String` of 32 hexadecimal characters.

```elm
MD5.hex ""          == "d41d8cd98f00b204e9800998ecf8427e"
MD5.hex "foobarbaz" == "6df23dc03f9b54cc38a0fc1483df6e21"
```

Unlike the [JavaScript function](https://css-tricks.com/snippets/javascript/javascript-md5/) from which this
implementation has been ported, CRLF pairs in the input are not automatically replaced with LFs prior to computing
the digest. If you want that behaviour, adjust the input before evaluating the function. For example:

```elm
myHex : String -> String
myHex input =
    let
        myInput =
            Regex.replace Regex.All (Regex.regex "\x0D\n") (\_ -> "\n") input
    in
        MD5.hex myInput
```

## Versioning

There are versions of this library for Elm 0.17.1 and 0.18.

Install the package as normal for Elm 0.18 (`elm package install sanichi/elm-md5`).

However, for Elm 0.17.1, there is an as yet undiagnosed problem with the normal method of installation.
Please use the following workaround:

1. Remove any dependency on `sanichi/elm-md5` from your `elm-package.json` if you haven't already done so.
1. Grab a copy of the 1.0.0 version of [MD5.elm](https://raw.githubusercontent.com/sanichi/elm-md5/1.0.0/src/MD5.elm) (the only file you need) and add it to your project's Elm files.
1. Make sure the file has been copied correctly (it's MD5 digest should be `101fd0190906aa0febfae987b86a03e1`).
1. Then use as normal (`import MD5` etc).
