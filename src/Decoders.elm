module Decoders exposing (decodeAllPackages, decodeDoc, decodeStoreModel)

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


decodeStoreModel : Json.Decoder StoreModel
decodeStoreModel =
    Json.map3 StoreModel
        (Json.field "docs" (Json.list decodeStoreDoc))
        (Json.field "searchIndex"
            (Json.list
                (Json.map2 (,)
                    (Json.index 0 Json.string)
                    (Json.index 1 Json.string)
                )
            )
        )
        (Json.oneOf
            [ Json.field "navWidth" Json.int
            , Json.succeed defaultStoreModel.navWidth
            ]
        )


decodeStoreDoc : Json.Decoder Doc
decodeStoreDoc =
    Json.map6 Doc
        (Json.field "id" Json.string)
        (Json.field "packageName" Json.string)
        (Json.field "packageVersion" Json.string)
        (Json.field "modules" (Json.list decodeStoreModule))
        (Json.field "readme" Json.string)
        (Json.field "navExpanded" Json.bool)


decodeStoreModule : Json.Decoder Module
decodeStoreModule =
    Json.map6 Module
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "aliases" (Json.list decodeStoreAlias))
        (Json.field "types" (Json.list decodeModuleType))
        (Json.field "values" (Json.list decodeStoreValue))
        (Json.field "generatedWithElmVesion" Json.string)


decodeStoreAlias : Json.Decoder Alias
decodeStoreAlias =
    Json.map4 Alias
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "args" (Json.list Json.string))
        (Json.field "type_" Json.string)


decodeStoreValue : Json.Decoder Value
decodeStoreValue =
    Json.map3 Value
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "type_" Json.string)
