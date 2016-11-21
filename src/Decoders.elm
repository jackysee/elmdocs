module Decoders exposing (decodeAllPackages, decodeDoc)

import Json.Decode as Json
import Models exposing (..)


decodeAllPackages : Json.Decoder (List Package)
decodeAllPackages =
    Json.list
        (Json.map3 Package
            (Json.field "name" Json.string)
            (Json.field "summary" Json.string)
            (Json.field "versions" (Json.list Json.string))
        )


decodeDoc : String -> String -> Json.Decoder Doc
decodeDoc packageName version =
    Json.map4 Doc
        (Json.succeed <| packageName ++ "#" ++ version)
        (Json.succeed packageName)
        (Json.succeed version)
        (Json.list decodeModule)


decodeModule : Json.Decoder Module
decodeModule =
    Json.map6 Module
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "aliases" (Json.list decodeAlias))
        (Json.field "types" (Json.list decodeModuleType))
        (Json.field "values" (Json.list decodeValue))
        (Json.field "generated-with-elm-version" Json.string)


decodeAlias : Json.Decoder Alias
decodeAlias =
    Json.map4 Alias
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "args" (Json.list Json.string))
        (Json.field "type" Json.string)


decodeModuleType : Json.Decoder ModuleType
decodeModuleType =
    Json.map4 ModuleType
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "args" (Json.list Json.string))
        (Json.field "cases" (Json.list decodeCase))


decodeCase : Json.Decoder ( String, List String )
decodeCase =
    Json.list Json.value
        |> Json.andThen
            (\list ->
                case list of
                    x :: y :: [] ->
                        let
                            result =
                                Result.map2 (,)
                                    (Json.decodeValue Json.string x)
                                    (Json.decodeValue (Json.list Json.string) y)
                        in
                            case result of
                                Ok value ->
                                    Json.succeed value

                                Err err ->
                                    Json.fail err

                    _ ->
                        Json.fail "not a case structure"
            )


decodeValue : Json.Decoder Value
decodeValue =
    Json.map3 Value
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "type" Json.string)
