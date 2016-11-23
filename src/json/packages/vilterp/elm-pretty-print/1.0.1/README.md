# Elm Pretty Printer

An Elm implementation of the pretty printing library described in Phil Wadler's paper ["A Prettier Printer"](http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf). 

![image](http://g.recordit.co/jQTyzAuhpb.gif)

Combinators here allow you to specify how a tree gets turned into text (you can choose HTML with custom attributes, or a simple string). You can

- specify indentation with `nest`
- use `group` to specify that a subtree should be on one line if it fits in the given width, or should have newlines if it doesn't.

Documentation is currently lacking; see `Example.elm` (pictured above) for usage, or the Wadler paper for description of the combinators.

This needs some optimization — a node with 10 children is quite slow to render on window resize in the example!
