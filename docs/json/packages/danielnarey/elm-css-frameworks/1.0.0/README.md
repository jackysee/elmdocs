## Embed a CSS Framework in Your Elm Program's View

This library provides access to popular CSS frameworks and feature libraries as
(long) strings of CSS code. The HTML `<style>` tag can be used to embed any of
these frameworks in an Elm program's view (see the
[`toStyleNode`](http://package.elm-lang.org/packages/danielnarey/elm-css-frameworks/latest/CssFrameworks#toStyleNode) function).

My main motivation for creating this package was to experiment with using CSS
frameworks in conjuction with my
[Stylesheet](http://package.elm-lang.org/packages/danielnarey/elm-stylesheet/latest)
library. I haven't tested whether this approach will appreciably improve page
loading times when compared to
[linking to the resource file on a CDN](http://package.elm-lang.org/packages/krisajenkins/elm-cdn/latest),
but I imagine it would speed up page loads a bit, particularly if it allows
multiple resources to be combined into one long string of CSS.

For now, however, my purpose is to experiment with different ways of working
with CSS in an Elm development environment. Some in-browser performance testing
would be needed before deciding whether to use this approach in production code.

Note that distributions for some of the frameworks (Bootstrap, Materialize,
FontAwesome) include font files, so in place of local file paths I inserted
links to CDN font resources. Also note that this package does not provide access
to JavaScript resources that add functionality to some frameworks.
