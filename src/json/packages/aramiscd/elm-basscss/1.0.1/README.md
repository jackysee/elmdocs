# elm-basscss

A simple attempt to make [Basscss](http://basscss.com/) available in Elm Reactor

```elm
import Bass exposing(style, center, h1, italic)


main =
    div
        [ style
            [ center
            , h1
            , italic
            ]
        ]
        [ text "Styled Heading" ]
```

Additional style declarations can be passed in as a list.

```elm
import Bass exposing(style, center, h1, italic)


main =
    div
        [ style
            [ center
            , h1
            , italic
            , [ ( "background-color", "red" )
              , ( "color", "green" )
              ]
            ]
        ]
        [ text "Heading In Terrible Colors" ]
```

That's it.



Basscss class selectors can be looked up at http://basscss.com/.  Dashes in Basscss selectors become underscores in `Bass.elm`.  Here is an example: This css rule...

```css
.list-reset{
  list-style:none;
  padding-left:0;
}
```

... looks like this in `Elm.bass`:

```elm
list_reset =
    [ ( "list-style", "none" )
    , ( "padding-left", "0" )
    ]
```

In fact that's all I've done here.  This module is really simple, it just allows me to style things based on class selectors, just like I would in plain HTML/CSS with a neat little toolkit like Basscss.

Basscss media queries and pseudo classes are missing, since they can't be used inline.

Enjoy!

(Published by Aramís Concepción Durán)
