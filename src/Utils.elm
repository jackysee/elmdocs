module Utils exposing (..)

import Html
import Html.Events exposing (onWithOptions)
import Json.Decode


findFirst : (a -> Bool) -> List a -> Maybe a
findFirst predicate list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            if predicate x then
                Just x
            else
                findFirst predicate xs


onNothing : Maybe a -> Maybe a -> Maybe a
onNothing a b =
    case b of
        Nothing ->
            a

        _ ->
            b


onClickInside : msg -> Html.Attribute msg
onClickInside msg =
    onWithOptions "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.Decode.succeed msg)
