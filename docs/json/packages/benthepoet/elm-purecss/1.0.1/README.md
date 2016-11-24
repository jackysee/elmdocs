# elm-purecss

A set of helpers for [Pure CSS](https://purecss.io).

## Examples

Functions are provided for all the standard classes. These are intended to be 
used in tandem with `Html.Attributes.class` or `Html.Attributes.classList`. 

### Basic Form

``` elm
import Html
import Html.Attributes
import Pure

view model = 
    Html.form [Html.Attributes.class Pure.form]
        [ Html.label [] [Html.text "Username"]
        , Html.input [] []
        , Html.button [Html.Attributes.class Pure.button] []
        ]
```

### Data Table

``` elm
import Html
import Html.Attributes
import Pure

view model = 
    Html.table 
        [ Html.Attributes.classList
            [ (Pure.table, True) 
            , (Pure.tableStriped, True)
            ]
        ]
        [ Html.tr []
            [ Html.th [] [Html.text "Storage Type"]
            , Html.th [] [Html.text "Capacity"]
            ]
        , Html.tr [] 
            [ Html.td [] [Html.text "Floppy Disk"]
            , Html.td [] [Html.text "1440000 bytes"]
            ]
        ]
```