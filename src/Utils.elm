module Utils exposing (..)

import Html exposing (a)
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


atIndex : Int -> List a -> Maybe a
atIndex index list =
    list
        |> List.indexedMap (,)
        |> findFirst (\( i, _ ) -> i == index)
        |> Maybe.map Tuple.second


onNothing : Maybe a -> Maybe a -> Maybe a
onNothing a b =
    case b of
        Nothing ->
            a

        _ ->
            b


joinMaybe : Maybe (Maybe a) -> Maybe a
joinMaybe mx =
    case mx of
        Just x ->
            x

        Nothing ->
            Nothing


onClickInside : msg -> Html.Attribute msg
onClickInside msg =
    onWithOptions "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.Decode.succeed msg)
