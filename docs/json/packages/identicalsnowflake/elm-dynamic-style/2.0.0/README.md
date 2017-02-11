# Simple, dynamic style effects in Elm

The goal of this library is make locally stateful, declarative CSS effects
(e.g., :hover, :focus, etc.) as easy in Elm as they are with stylesheets.

For example, the following achieves the same effect as setting the
:hover attribute in your stylesheet:

```haskell
div (hover [("color","blue","lightblue")]) [text "so cool!"]
```

You may use the primed versions as shorthand to provide a base list of
styles, like this:

```haskell
div (hover_
    [ ("font-size","20px")
    , ("font-face","Droid Sans Mono")]
    [("color","blue","lightblue")])
    [text "wow"]
```

Also interacts nicely with my typed styles library, like so:

```haskell
div (hover_
    [ fontSize 30 px
    , padding 20 px
    , textCenter]
    [ color_ black blue ])
    [text "wow"]
```

Completely painless!

* Note: the effects in this library consume whatever JS hooks are needed
to achieve the effect on that element (e.g., hover consumes onmouseover and
onmouseout, but you are still free to use onclick). If for some reason you
do want to do both a CSS transition and have your application respond to
an event, you can simply make a wrapper element and hook its events.
