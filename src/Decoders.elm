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
    Json.map6 Doc
        (Json.succeed <| packageName ++ "/" ++ version)
        (Json.succeed packageName)
        (Json.succeed version)
        (Json.list decodeModule)
        (Json.succeed "")
        (Json.succeed False)


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
    Json.map2 (,)
        (Json.index 0 Json.string)
        (Json.index 1 (Json.list Json.string))


decodeValue : Json.Decoder Value
decodeValue =
    Json.map3 Value
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "type" Json.string)
