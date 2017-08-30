# elm-istring

[![Build Status](https://travis-ci.org/arowM/elm-istring.svg?branch=master)](https://travis-ci.org/arowM/elm-istring)

## Summary

A module to handle unexpected behavior when using `lazy` with `input` tag.

## When should we use this?

If you use [`Html.Lazy.lazy`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html-Lazy#lazy) (or `lazy2`, `lazy3`, etc...) to a view function it contains `input` tag,
you should give a thought to use `IString`.

Let's see one example case that have to use `IString`.
Here is a excerpt of an [example code](https://github.com/arowM/elm-istring/blob/master/example/src/Strict.elm) in [`/example` directory](https://github.com/arowM/elm-istring/tree/master/example).

```
type alias Model =
    { ...
    , value : String
    }


type Msg
    = ...
    | UpdateValue String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ...

        UpdateValue str ->
            ( { model
                | value = normalize str
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div
        []
        [ ...
        , digitInput model.value
        ]


digitInput : String -> Html Msg
digitInput str =
    Debug.log "digitInput was called." <|
        input
            [ onInput UpdateValue
            , value str
            ]
            []
```

This code do just update `model.value` when a user inputs a key on the `input` tag.
The only thing, that is special, is it do some sort of "normalization" before updates.

```
{-| Filter only digit characters.

    normalize "s"
    --> ""

    normalize "9"
    --> "9"

    normalize "asl20la2"
    --> "202"

-}
normalize : String -> String
normalize =
    String.fromList << List.filter Char.isDigit << String.toList
```

Here, the `normalize` function above only filters digit characters.
As a result, only digit characters are shown on the `input` tag.
All user inputs except digit characters are discarded.

Let's assume that you pushed keyboard keys "s" "3" "a" sequentially.
The first "s" you entered does not affect at all because it is not a digit number.
After pushing second key "3", the input field shows "3" as it is the only digit character you pushed.
And finally, when you input "a", it still shows "3".

Here's [sample page](https://arowm.github.io/elm-istring/strict.html), which built the source code above.

One of the problem of this code is that this calles `digitInput` on every time some event updates `Model`, even if the updates are not related to `model.value`.

You can assure that by opening web console on the sample page.
All the time you click "dummy event" button, which does not affect `model.value` at all, `digitInput was called.: ...` will be printed on your web console.

So, here we should use `Html.Lazy.lazy` to reduce useless rerendering of `digitInput`.
I'll pick up a snippet from [`example/src/Lazy.elm`](https://github.com/arowM/elm-istring/blob/master/example/src/Lazy.elm).

```
view : Model -> Html Msg
view model =
    div
        []
        [ ...
        , lazy digitInput model.value
        ]
```

It only changes to use `lazy` on `view` function.

Though it successfully reduces some useless rerendering events, it changes the behavior of input field!

To ensure, enter "s" "3" "a", as previously we did, on [sample page](https://arowm.github.io/elm-istring/lazy.html).
If you enter "s", it shows "s" on input field and the "s" remains till you push "3".
Furthermore, if you input "a" after that, "3a" is shown on the input field...

This is because `input` tags have some sort of their own state, and it breaks Single Source of Truth of our code.

Initially, `model.value` is `""`, and the input `tag` has state `""` as its `value`.
How it goes after entering "s"?
The `normalize` function convert it to `""`, it is as same as initial value, so `lazy` decides not to rerender `digitInput`.
On the other hand, the `input` tag changes its state `""` to `"s"`, and it is not overwritten by Elm because `digitInput` is not called.
This causes the unexpected behavior mentioned above.

The `IString` solves this problem.
You only have to replace the type of `model.value` `String` with `IString`, and ask compiler what to do.
See [example](https://github.com/arowM/elm-istring/blob/master/example/src/Lazy2.elm) for details.
