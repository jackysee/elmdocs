# select-prism

A `<select>` is basically the <abbr title="user interface">UI</abbr> representation of a [union type](http://elm-lang.org/docs/syntax#union-types) or <abbr title="algebraic data type">ADT</abbr>.Using a `Prism` and it's data structure for a data transformation that's not quite isomorphic, we can use go from an <abbr title="algebraic data type">ADT</abbr> to a `String` and back like we'd prefer to do.


```elm
import Html exposing (..)
import Html.SelectPrism exposing (selectp)


view : Model -> Html Msg
view { selectedColor } =
    -- Right Here ↓
    selectp colorp ChangeColor selectedColor [] colorOptions


colorOptions : List ( String, Color )
colorOptions =
    [ ( "❤️  Red", Red )
    , ( "💙 Blue", Blue )
    , ( "💚 Green", Green )
    ]


type alias Model =
    { selectedColor : Color }


type Msg
    = ChangeColor (Result String Color)


type Color
    = Red
    | Blue
    | Green


{-| You the developer are responsible for this `Prism`s correctness
-}
colorp : Prism String Color
colorp =
    let
        colorFromString : String -> Maybe Color
        colorFromString s =
            case s of
                "red" ->
                    Just Red

                "green" ->
                    Just Green

                "blue" ->
                    Just Blue

                _ ->
                    Nothing

        colorToString : Color -> String
        colorToString c =
            case c of
                Red ->
                    "red"

                Green ->
                    "green"

                Blue ->
                    "blue"
    in
        -- Using `Prism` as a constructor
        Prism colorFromString colorToString
```

Do check out [the example](https://github.com/toastal/select-prism/blob/master/examples/HeartColors.elm) and/or read [my blog entry](https://toast.al/posts/2017-01-13-playing-with-prisms-for-the-not-so-isomorphic.html) which goes into more depth.

