# Simple Port Program for Elm

## What does this do?

SimplePortProgram exposes only what's necessary to make your Elm functionality interoperate with arbitrary JavaScript.

Deprecated as of Elm 0.18.0 thanks to Platform.program effectively doing the same thing.

For Elm 0.18.0, instead see our [Port Program Examples](https://github.com/Pilatch/elm-port-program-examples).

## Why?

Elm 0.17.1 needed a better way to demonstrate how ports work. Though there is some good documentation for Elm, most has revolved around HTML. Examples that don't actually use HTML, for Node JS, still have a significant amount of cruft to hamper a beginner's understanding of how to get a minimal proof of concept working.

Models probably aren't needed for simple use either, so SimplePortProgram provides a way to interoperate without that worry. You only need to concern yourself with the structure of data coming and going to/from Elm, and how to act on messages.

## Try it out

Look in the examples folder. It's pretty straightforward.

## Links

[Official Elm-JavaScript interoperation documentation](https://guide.elm-lang.org/interop/javascript.html)

[Elm Effects](https://guide.elm-lang.org/architecture/effects/)

[Elm Platform.Cmd v5.0.0](http://package.elm-lang.org/packages/elm-lang/core/latest/Platform-Cmd)

[Elm Platform.Sub v5.0.0](http://package.elm-lang.org/packages/elm-lang/core/5.0.0/Platform-Sub)
