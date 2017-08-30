## A flexible API for generating a complete CSS stylesheet in Elm

This library builds off of my
[CssBasics](http://package.elm-lang.org/packages/danielnarey/elm-css-basics/latest)
package to allow the user to generate a complete CSS stylesheet in Elm. I
created it to provide a more flexible alternative to other CSS-in-Elm packages
that would let me write CSS in a way that conforms to my stylistic preferences
for Elm code. The tradeoff for this flexibility is that it was not designed to
safeguard the user from generating invalid CSS.

### Getting Started

The best way to get started with this library is to familiarize yourself with
the syntax for style declarations used by
[CssBasics](http://package.elm-lang.org/packages/danielnarey/elm-css-basics/latest/CssBasics),
then check out this simple, self-contained
[example](https://github.com/danielnarey/elm-stylesheet/tree/master/examples/BasicUse.elm).

### Supported Features

In addition to constructing basic rule sets with element, id, class, and
attribute selectors, the current version of `elm-stylesheet` provides support
for:
- combinator selectors (including pseudo-classes and pseudo-elements)
- media queries
- import statements (with helpers for Google Font imports)
- prepending strings of CSS code to your stylesheet
- embedding a stylesheet in your Elm program's view
- exporting a stylesheet to a *.css* file using rtfeldman's [elm-css](https://github.com/rtfeldman/elm-css) Node module

### How to Export to a *.css* File using `elm-css`

Exporting to a .css file using [elm-css](https://github.com/rtfeldman/elm-css)
requires a specially formatted port module. Copy this
[template](https://github.com/danielnarey/elm-stylesheet/tree/master/examples/Stylesheets.elm)
to the directory that contains your stylesheet module. Replace `BasicUse` with
the name of your module and `BasicUse.myStylesheet` with the name of the
function that returns the stylesheet you want to export. You can specify the
name of the file to be created by changing `"myCssFile.css"` to whatever you
want.

To install `elm-css`, run the following in your terminal:
```
$ npm install -g elm-css
```

Then run installed module, giving it the path to your `Stylesheets.elm` file, for example:
```
$ elm-css src/Stylesheets.elm
```

If the compiler returns an error, check your file paths and exposed modules. 

__Dependencies:__
- [elm-lang/core/5.1.1](http://package.elm-lang.org/packages/elm-lang/core/5.1.1)
- [elm-lang/html/2.0.0](http://package.elm-lang.org/packages/elm-lang/html/2.0.0)
- [danielnarey/elm-css-basics/3.0.1](http://package.elm-lang.org/packages/danielnarey/elm-css-basics/3.0.1)

__Credits:__  

The approach to generating CSS used in this library is based on the
[elm-css package](https://github.com/massung/elm-css) by Jeffrey Massung,
version 1.1, licensed under BSD-3. I retained Massung's basic approach to
"compiling" a stylesheet that will be applied when rendering a view, but I
changed a lot of the implementation details, renamed some things, and added
a number of features.

The [elm-css](https://github.com/rtfeldman/elm-css) Node module, which may be used with this package to generate an external *.css* file, was created by Richard Feldman and is licensed under BSD-3.
