## Embed a CSS framework in your Elm program's view (experimental)

This package provides access to popular CSS frameworks and feature libraries as
(long) strings of CSS code. The HTML `<style>` tag can be used to embed any of
these frameworks in an Elm program's view (see the
[`toStyleNode`](http://package.elm-lang.org/packages/danielnarey/elm-css-frameworks/latest/CssFrameworks#toStyleNode) function).

My motivation for creating this package was to experiment with using CSS
frameworks in conjunction with my
[Stylesheet](http://package.elm-lang.org/packages/danielnarey/elm-stylesheet/latest)
library. This approach seems to work adequately in terms of browser rendering,
but it might not be optimal. I haven't tested whether embedding the CSS code
will improve page loading times when compared to
[linking to the resource file on a CDN](http://package.elm-lang.org/packages/krisajenkins/elm-cdn/latest).

Note that distributions for some of the frameworks (Bootstrap, Materialize,
FontAwesome) include font files, so in place of local file paths I inserted
links to CDN font resources. Also note that this package does not provide access
to JavaScript resources that add functionality to some frameworks.
