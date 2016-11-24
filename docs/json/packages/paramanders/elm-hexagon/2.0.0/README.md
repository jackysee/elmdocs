# elm-hexagon

Create svg hexagons with rounded corners in Elm.

Example:

```
main : Svg msg
main =
    svg [ viewBox "0 0 500 500", height "500", width "500" ]
        [ svgHexagon [fill "#000000"] <| hex (p 250 250) 15 125
        ]
```
