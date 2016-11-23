# elm-piano

![image](https://raw.githubusercontent.com/sh4r3m4n/elm-piano/master/img/piano.png)

## Description

This package exports a simple, optionally interactive piano component for
the Elm programming language. You can use it to create music aplications or
similar.

The package itself does not handle any sound or other side effect, so the
component's only function is only to render an object that looks like a piano
and select which key to appear to be pressed. Also it has an experimental,
not fully functional interactive mode so the keys the user clicks are markerd
as pressed.

If you want to see examples of how to use it to generate sound you should 
check the example programs that use a MIDI.js port lo do it.

## Documentation and examples

The documentation of this package is available on http://package.elm-lang.org/packages/sh4r3m4n/elm-piano/.

[Example 1](https://sh4r3m4n.github.io/elm-piano/examples/playmidi.html): Show the notes of a MIDI file

[Example 2](https://sh4r3m4n.github.io/elm-piano/examples/interactive.html): Interactive keyboard with sound. Has some UI issues.

## Credits

The HTML and CSS of the piano is based on [michaelmp/js-piano][jspiano]

[jspiano]: https://github.com/michaelmp/js-piano
