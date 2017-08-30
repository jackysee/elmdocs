# elm-rating



A rating component in Elm.


## Usage

The Rating need a Rating Model on your model  like this:

```elm
    type alias Model =
        { rating : Rating.Model }
```

The view will be update based on this rating. Rating expose `defaultModel`.

I recomend just change the variables:  quantity, svgDefault, svgSelected, svgOver, svgParentAtributes, svgParentClass, readOnly.

For you use set svgDefault, svgSelected and svgSelected for the three types of status of svgs.
Another choice is use svgParentClass or svgParentAtributes with the data-atribute at div parent of svgs. For all the svgs selected is added "data-selected" = True  and "data-over" = True at div.

If you need to show rating defined, change rating and rating Percent.

Dont modify isOver, ratingOver.

```elm
type alias Model =
    { rating : Maybe Int
    , quantity : Int
    , svgDefault : Svg.Svg Msg
    , svgSelected : Svg.Svg Msg
    , svgOver : Svg.Svg Msg
    , svgParentAtributes : List ( String, String )
    , svgParentClass : List ( String, Bool )
    , ratingPercent : Float
    , isOver : Bool
    , ratingOver : Maybe Int
    , readOnly : Bool
    }
```

```elm
initial : Model
initial =
    Model Rating.defaultModel
```

The Rating can be displayed in a view using the Rating.view function. It returns its own message type so you should wrap it in one of your own messages using Html.map:
```elm
type Msg
    = ...
    | RatingMessage Rating.Msg
    | ...
```
```elm
view : Model -> Html Msg
view model =
    ...
    div [] [
            Html.map RatingMessage (Rating.view model.rating)
        ]
```
In order handle `Msg` in your update function, you should unwrap the `Rating.Msg` and pass it
down to the `Rating.update` function. The `Rating.update` function returns the Rating Model updated.

```elm
update : Msg -> Model -> ( Model, Cmd, Msg )
update msg model =
    case msg of
        ...

         RatingMessage msg ->
            let
                ( updateRating, subCmd ) =
                    Rating.update msg model.rating
            in
                { model | rating = updateRating } ! [ Cmd.map RatingMessage subCmd ]

```

## Examples

See the [examples][examples] folder or try it on ellie-app: [example1] example.

[examples]: https://github.com/Bernardoow/Elm-Rating-Component/tree/master/examples
[example1]: https://ellie-app.com/CfKBF6K3DFa1/0


##
SVG Start Found at [star_source]


[star_source]: https://codepen.io/brianknapp/pen/JEotD/