module App exposing (..)

import Html exposing (Html, text, div)
import Json.Decode as Json
import Http


-- import Task


type alias Package =
    { name : String
    , summary : String
    , version : List String
    }


type alias Doc =
    { packageName : String
    , packageVersion : String
    , modules : List Module
    }


type alias Module =
    { name : String
    , comment : String
    , aliases : List Alias
    , types : List ModuleType
    , values : List Value
    }


type alias Alias =
    { name : String
    , comment : String
    , args : List String
    , type_ : String
    }


type alias ModuleType =
    { name : String
    , comment : String
    , args : List String
    , cases : List ( String, List String )
    }


type alias Value =
    { name : String
    , comment : String
    , type_ : String
    }


type alias Model =
    { allPackages : List Package
    , pinnedDocs : List Doc
    }


init : Maybe Json.Value -> ( Model, Cmd Msg )
init str =
    { allPackages = []
    , pinnedDocs = []
    }
        ! [ getAllPackages (str == Nothing)
          ]


getAllPackages : Bool -> Cmd Msg
getAllPackages loadDefault =
    --    Task.attempt LoadAllPackages
    --        (Http.toTask <| Http.get "json/all-packages.json" decodeAllPackages)
    Http.get "json/all-packages.json" decodeAllPackages
        |> Http.send LoadAllPackages


decodeAllPackages : Json.Decoder (List Package)
decodeAllPackages =
    Json.list
        (Json.map3 Package
            (Json.field "name" Json.string)
            (Json.field "summary" Json.string)
            (Json.field "versions" (Json.list Json.string))
        )


getDoc : String -> String -> Cmd Msg
getDoc moduleName version =
    Http.get
        ("json/packages/"
            ++ moduleName
            ++ "/"
            ++ version
            ++ "/documentation.json"
        )
        (decodeDoc moduleName version)
        |> Http.send PinDoc


decodeDoc : String -> String -> Json.Decoder Doc
decodeDoc moduleName version =
    Json.map3 Doc
        (Json.succeed moduleName)
        (Json.succeed version)
        (Json.list decodeModule)


decodeModule : Json.Decoder Module
decodeModule =
    Json.map5 Module
        (Json.field "name" Json.string)
        (Json.field "comment" Json.string)
        (Json.field "aliases" (Json.list decodeAlias))
        (Json.field "types" (Json.list decodeModuleType))
        (Json.field "values" (Json.list decodeValue))


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


type Msg
    = NoOp
    | LoadAllPackages (Result Http.Error (List Package))
    | PinDoc (Result Http.Error Doc)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadAllPackages (Ok list) ->
            ( { model | allPackages = list }, Cmd.none )

        LoadAllPackages (Err _) ->
            ( model, Cmd.none )

        PinDoc _ ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        (model.allPackages
            |> List.map (\p -> div [] [ text p.name ])
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
