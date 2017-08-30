elm-style
=========

Composable styles in Elm. Instead of using the cascade, you can use Elm to compose and reuse styles in your app.

Special thanks to [Adam Kowalski](github.com/adam-r-kowalski) for creating the initial version of this.

Why Inline styles instead of stylesheets?
-----------------------------------------

Inspired by [React: CSS in JS](https://speakerdeck.com/vjeux/react-css-in-js) by vjeux

[Relevant discussion on Elm Discuss](https://groups.google.com/forum/#!topic/elm-discuss/bv9X2TYXO34)

TODO: explain more

Features
--------
- Composable Styles
- Type checking
- Automatic vendor prefixing

Example
-------

### Centering Content
```elm
import Html exposing (..)
import Style exposing (..)

centeredLayout : List Style
centeredLayout =
  [ display flex'
  , justifyContent center
  , alignItems center
  ]

columnLayout : Styles
columnLayout =
  [ display flex'
  , flexDirection column
  ]


-- we can compose specific styles with the reusable "columnLayout", above
container : Styles 
container =
  List.concat
        [ columnLayout
        , [ position absolute
          , width (pc 100)
          , height (pc 100)
          , fontFamily "sans-serif"
          ]
        ]

view : Html
view =
  div [ style centeredLayout ] [ text "Hello, world!" ]
```

See [./example/MyStyles.elm](./example/MyStyles.elm) for a complete example.

The code is almost identical to its Css counterpart, but instead of using hyphen-delimited syntax you use the Elm camelCase.  There is one more thing to look out for. As you can see some values in the key value pair end in an `'` (ie: `flex'`).  This is done whenever there is both a key and a value that both have the same name. In this case the key will always have the non quoted name.  Therefore `flex` is a function which sets the `flex-grow`, `flex-shrink`, and `flex-basis` values, while `flex'` is the value that can be supplied to `display` function to enable a flex context for all its direct children.


Related Libraries
-----------------

[elm-dynamic-style](http://package.elm-lang.org/packages/garetht/elm-dynamic-style/1.0.3/) - add hover effects using this method. I expect to create an alternative to this that lets you use it with this library.

[elm-css](http://package.elm-lang.org/packages/rtfeldman/elm-css/) - Generate .css files from Elm

