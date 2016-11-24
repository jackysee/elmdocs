#SVG Path DSL - An Elm DSL for SVG Path elements

A nicer way to create svg paths. 

Svg paths are easy to read for computers, but not for humans. This package provides a nicer 
way to create paths, providing safety (no runtime exceptions!) and less room for typos.

#Example 

```elm
module Cross exposing (main)

-- source: https://github.com/gampleman/elm-visualization/blob/1.0.0/examples/Cross.elm

import Svg exposing (svg, g, path)
import Svg.Attributes exposing (transform, d, stroke, fill, strokeLinejoin, strokeWidth)
import Svg.Path exposing (pathToString, subpath, startAt, lineToMany, emptySubpath, closed)


cross =
    [ ( -60, -20 )
    , ( -20, -20 )
    , ( -20, -60 )
    , ( 20, -60 )
    , ( 20, -20 )
    , ( 60, -20 )
    , ( 60, 20 )
    , ( 20, 20 )
    , ( 20, 60 )
    , ( -20, 60 )
    , ( -20, 20 )
    , ( -60, 20 )
    ]


polygon ps =
    case ps of
        [] ->
            emptySubpath

        x :: xs ->
            subpath (startAt x) closed [ lineToMany xs ]


main =
    svg []
        [ g [ transform "translate(70,70)" ]
            [ path
                [ d (pathToString [ polygon cross ])
                , stroke "#000"
                , fill "none"
                , strokeLinejoin "round"
                , strokeWidth "10"
                ]
                []
            ]
        ]
```

Draws 
<svg>
<g transform="translate(70,70)">
<path d="M-60,-20 L-20,-20 L-20,-60 L20,-60 L20,-20 L60,-20 L60,20 L20,20 L20,60 L-20,60 L-20,20 L-60,20 Z" stroke="#000" fill="none" stroke-linejoin="round" stroke-width="10"></path>
</g>
</svg>



#What's next

This is a very basic library. See it as a basic building block to build more 
complex libraries with. 

Here are some ideas:

* A parser for paths.
* Optimizing paths (for example joining multiple lineTo's into one lineToMany)
* Higher-level functionality - composing paths 
* type-safe svg 
* graphics libraries, inspired by Haskell's [diagrams](http://projects.haskell.org/diagrams/) or OCaml's [Vg](http://erratique.ch/software/vg/doc/Vg.html) or 
the ideas discussed in [funcional image synthesis](http://conal.net/papers/bridges2001/bridges-medres.pdf).
* visualization libraries (like D3)

Please contact me if you want to work or collaborate on these!


