## A CSS implementation with helpful constructors for generating a global stylesheet

This library builds off of
[CssBasics](http://package.elm-lang.org/packages/danielnarey/elm-css-basics/latest)
to allow you to generate a stylesheet and embed it in your Elm
program's view.

In a browser fully compliant with the HTML 5 specification, you would be able to
"scope" the stylesheet so that it is only applied to its parent element and all
of that element's children, allowing you to embed multiple stylesheets that
apply to different sections of the document. Unfortunately, as of October
2016, Firefox is the only browser that has implemented this scoping feature.
Thus, for the time being, recommended use of this library is to follow standard
practice and create one stylesheet that applies globally to the document.
Instead of linking to an external CSS file, however, this library allows you to
embed CSS code between `<style>` tags in the body of the HTML DOM.

Whereas it is standard practice to include `<style>` tags in the `<head>` of the
document, Elm does not currently provide an interface to insert code into the
document's `<head>`. This seems not to be a problem, as no difference in
performance is apparent when `<style>` tags are inserted in the `<body>` of the
document instead.

The basic workflow for using this library is (1) create your rule sets,
consisting of selectors (identifying elements) and declarations (defining
styles), (2) add your rule sets to a new stylesheet along with any import URLs
needed to access external resources (e.g., Google fonts), and (3) embed the
stylesheet at the root level of your HTML DOM. The constructor functions
included with this library allow for semantically pleasing code that uses
functional operators to chain expressions, making it easy to read and modify
your CSS as you iterate your UI design.

See
[examples/BasicUse.elm](https://github.com/danielnarey/elm-stylesheet/tree/master/examples)
for a full working example.

__Dependencies:__
- [elm-lang/core/5.0.0](http://package.elm-lang.org/packages/elm-lang/core/5.0.0)
- [elm-lang/html/2.0.0](http://package.elm-lang.org/packages/elm-lang/html/2.0.0)
- [danielnarey/elm-toolkit/3.0.0](http://package.elm-lang.org/packages/danielnarey/elm-toolkit/3.0.0)
- [danielnarey/elm-css-basics/1.0.1](http://package.elm-lang.org/packages/danielnarey/elm-css-basics/1.0.1)

__Credits:__  
The approach to generating CSS used in this library is based on the
[elm-css package](https://github.com/massung/elm-css) by Jeffrey Massung,
version 1.1, licensed under BSD-3. I retained Massung's basic approach to
"compiling" a stylesheet that will be applied when rendering a view, but I
changed a lot of the implementation details, renamed some things, and added
a number of features.
