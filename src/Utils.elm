module Utils exposing (..)

import Html exposing (a)
import Html.Events exposing (onWithOptions)
import Json.Decode
import Regex
import String.Extra


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


findIndex : (a -> Bool) -> List a -> Maybe Int
findIndex predicate list =
    list
        |> List.indexedMap (,)
        |> findFirst (\( i, a ) -> predicate a)
        |> Maybe.map Tuple.first


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


simpleMatch : String -> String -> Bool
simpleMatch text path =
    let
        re =
            String.split "" text
                |> List.map Regex.escape
                |> String.join ".*"
                |> (\s -> "^.*" ++ s ++ ".*$")
                |> Regex.regex
                |> Regex.caseInsensitive
    in
        Regex.contains re path


sortPath : String -> String -> String -> ( Int, String )
sortPath separator text pathId =
    let
        name =
            String.Extra.rightOfBack separator pathId
    in
        ( if text == name then
            1
          else if String.startsWith text name then
            2
          else if String.contains text name then
            3
          else
            4
        , pathId
        )


hasDuplicate : (a -> Bool) -> List a -> Bool
hasDuplicate predicate list =
    let
        search =
            \list count ->
                case list of
                    [] ->
                        False

                    x :: xs ->
                        let
                            count_ =
                                if predicate x then
                                    count + 1
                                else
                                    count
                        in
                            if count_ == 2 then
                                True
                            else
                                search xs count_
    in
        search list 0
