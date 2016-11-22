module App exposing (..)

import Html exposing (Html, text, div, input, h1, h3, br, span)
import Html.Attributes exposing (class, style, value, placeholder)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Json
import Http
import Models exposing (..)
import Decoders exposing (..)
import Msgs exposing (..)
import String
import Markdown
import Regex
import Dict exposing (Dict)


init : Maybe Json.Value -> ( Model, Cmd Msg )
init storedModel =
    { allPackages = []
    , pinnedDocs = []
    , currentDoc = Nothing
    , searchIndex = []
    , searchResult = []
    , searchText = ""
    , showDisabled = False
    }
        ! [ getAllPackages (storedModel == Nothing)
          ]


getAllPackages : Bool -> Cmd Msg
getAllPackages loadDefault =
    Http.get "json/all-packages.json" decodeAllPackages
        |> Http.send (LoadAllPackages loadDefault)


getDocRequest : String -> String -> Http.Request Doc
getDocRequest moduleName version =
    Http.get
        ("json/packages/"
            ++ moduleName
            ++ "/"
            ++ version
            ++ "/documentation.json"
        )
        (decodeDoc moduleName version)


getDocs : List ( String, String ) -> Cmd Msg
getDocs list =
    case list of
        ( moduleName, version ) :: xs ->
            getDocRequest moduleName version
                |> Http.send (PinDoc xs)

        [] ->
            Cmd.none


getDefaultDocs : Model -> Cmd Msg
getDefaultDocs model =
    getDocs
        (model.allPackages
            |> List.filter
                (\p ->
                    List.member p.name
                        [ "elm-lang/core"
                        , "elm-lang/http"
                        , "elm-lang/virtual-dom"
                        ]
                )
            |> List.filterMap
                (\p ->
                    List.head p.versions
                        |> Maybe.map (\v -> ( p.name, v ))
                )
        )


buildSearchIndex : List ( String, String ) -> Doc -> List ( String, String )
buildSearchIndex list doc =
    let
        docIndexes =
            doc.modules
                |> List.concatMap
                    (\m ->
                        [ m.name ]
                            ++ List.map
                                (\name -> m.name ++ "." ++ name)
                                (List.map .name m.aliases
                                    ++ List.map .name m.types
                                    ++ List.map .name m.values
                                )
                    )
                |> List.map (\path -> ( path, doc.id ))
    in
        list ++ docIndexes


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LoadAllPackages loadDefault (Ok list) ->
            let
                model_ =
                    { model | allPackages = list }

                cmd_ =
                    if loadDefault then
                        getDefaultDocs model_
                    else
                        Cmd.none
            in
                ( model_, cmd_ )

        LoadAllPackages loadDefault (Err _) ->
            ( model, Cmd.none )

        PinDoc rest (Ok doc) ->
            ( { model
                | pinnedDocs = model.pinnedDocs ++ [ doc ]
                , searchIndex = buildSearchIndex model.searchIndex doc
              }
            , getDocs rest
            )

        PinDoc rest (Err err) ->
            ( model, getDocs rest )

        GetCurrentDocFromPackage package ->
            case List.head package.versions of
                Just version_ ->
                    ( model
                    , getDocRequest package.name version_
                        |> Http.send (Result.map (SetCurrentDoc "") >> Result.withDefault NoOp)
                    )

                Nothing ->
                    ( model, Cmd.none )

        GetCurrentDocFromId str ->
            case String.split "#" str of
                name :: version :: [] ->
                    ( model
                    , getDocRequest name version
                        |> Http.send (Result.map (SetCurrentDoc "") >> Result.withDefault NoOp)
                    )

                _ ->
                    ( model, Cmd.none )

        SetCurrentDoc nav doc ->
            ( { model | currentDoc = Just ( nav, doc ) }, Cmd.none )

        Search text ->
            ( { model
                | searchText = text
                , searchResult =
                    if String.isEmpty text then
                        []
                    else
                        List.filter
                            (\( path, docId ) ->
                                String.contains
                                    (String.toLower text)
                                    (String.toLower path)
                            )
                            model.searchIndex
              }
            , Cmd.none
            )

        ToggleShowDisabled ->
            ( { model | showDisabled = not model.showDisabled }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ div [ class "nav" ]
            [ div [ class "nav-top " ]
                [ input
                    [ class "search-input"
                    , onInput Search
                    , value model.searchText
                    , placeholder "Search..."
                    ]
                    []
                ]
            , if model.searchText /= "" then
                if List.length model.searchResult > 0 then
                    div [ class "nav-list nav-result" ] <|
                        List.map
                            (\( path, docId ) ->
                                div
                                    [ class "nav-item"
                                    , onClick (GetCurrentDocFromId docId)
                                    ]
                                    [ text <| Debug.log "path" path ]
                            )
                            model.searchResult
                else
                    div [] [ text "No result found" ]
              else
                div
                    [ class "nav-list" ]
                    [ div [ class "nav-pinned" ] <|
                        List.map
                            (\d ->
                                div
                                    [ class "nav-item"
                                    , onClick (SetCurrentDoc "" d)
                                    ]
                                    [ text <| d.packageName ++ " - " ++ d.packageVersion ]
                            )
                            model.pinnedDocs
                    , div
                        [ class "nav-packages nav-item" ]
                        [ div
                            [ onClick ToggleShowDisabled ]
                            [ text <| "Disabled" ]
                        , if model.showDisabled then
                            div [] <|
                                List.map
                                    (\p ->
                                        div
                                            [ class "nav-item"
                                            , onClick (GetCurrentDocFromPackage p)
                                            ]
                                            [ text p.name ]
                                    )
                                    model.allPackages
                          else
                            text ""
                        ]
                    ]
            ]
        , div [ class "doc" ]
            [ case model.currentDoc of
                Just ( path, doc ) ->
                    div
                        []
                        [ if path == "" then
                            viewDocOverview doc
                          else
                            viewModule path doc
                        ]

                Nothing ->
                    text ""
            ]
        ]


viewDocOverview : Doc -> Html Msg
viewDocOverview doc =
    div
        [ class "doc-overview" ]
    <|
        [ h1 [] [ text <| doc.packageName ++ "/" ++ doc.packageVersion ] ]
            ++ List.map
                (\m ->
                    div
                        [ onClick (SetCurrentDoc m.name doc) ]
                        [ text m.name ]
                )
                doc.modules


viewModule : String -> Doc -> Html Msg
viewModule path doc =
    let
        module_ =
            List.filter (\m -> String.startsWith m.name path) doc.modules |> List.head
    in
        case module_ of
            Just m ->
                div
                    [ class "module-doc" ]
                    [ h1 [] [ text <| m.name ]
                    , div [] <| viewModuleComment m.comment m
                    ]

            Nothing ->
                div [] [ text "module not found." ]


viewModuleComment : String -> Module -> List (Html Msg)
viewModuleComment comment module_ =
    let
        docs =
            Regex.split Regex.All (Regex.regex "@docs [^\\n]*\\n") (Debug.log "comment" comment)
                |> Debug.log "docs"
                |> List.map (Markdown.toHtml [])

        matches =
            Regex.find Regex.All (Regex.regex "@docs ([^\\n]*)\\n") comment

        entryDict =
            List.map (\v -> ( v.name, AliasEntry v )) module_.aliases
                ++ List.map (\v -> ( v.name, ModuleTypeEntry v )) module_.types
                ++ List.map (\v -> ( v.name, ValueEntry v )) module_.values
                |> Dict.fromList

        parts =
            matches
                |> List.map
                    (\m ->
                        m.submatches
                            |> List.filterMap identity
                            |> List.concatMap
                                (\listStr ->
                                    Regex.split Regex.All (Regex.regex ",\\s*") listStr
                                )
                            |> List.map (viewPart module_.name entryDict)
                    )
    in
        (List.map2 (\x y -> [ x ] ++ y) docs parts |> List.concat)
            ++ List.drop (List.length parts) docs


viewPart : String -> Dict String Entry -> String -> Html Msg
viewPart moduleName dict part =
    case Dict.get part dict of
        Just entry ->
            case entry of
                AliasEntry alias ->
                    div [ class "entry" ]
                        [ h3 [] <|
                            [ div [] [ text <| "type alias " ++ alias.name ++ " = " ]
                            , div [ class "entry-name" ] [ text <| alias.type_ ]
                            ]
                                ++ List.map (\arg -> text <| " " ++ arg) alias.args
                        , Markdown.toHtml [ class "entry-comment" ] alias.comment
                        ]

                ModuleTypeEntry tipe ->
                    div [ class "entry" ]
                        [ h3 [] <|
                            [ text "type "
                            , span [ class "entry-name" ] [ text tipe.name ]
                            , text <| " " ++ String.join " " tipe.args
                            ]
                                ++ (if List.length tipe.cases > 0 then
                                        tipe.cases |> List.indexedMap viewCase
                                    else
                                        [ text "" ]
                                   )
                        , Markdown.toHtml [ class "entry-comment" ] tipe.comment
                        ]

                ValueEntry value ->
                    div [ class "entry" ]
                        [ h3 [] <|
                            [ span [ class "entry-name" ] [ text value.name ]
                            , span [ class "value-type" ] <| viewType moduleName value.type_
                            ]
                        , Markdown.toHtml [ class "entry-comment" ] value.comment
                        ]

        Nothing ->
            text ""


viewCase : Int -> ( String, List String ) -> Html Msg
viewCase i ( case_, caseArgs ) =
    let
        prefix =
            if i == 0 then
                "="
            else
                "|"

        caseStr =
            [ prefix
            , case_
            , String.join " " caseArgs
            ]
                |> String.join " "
    in
        div [ class "cases" ] [ text caseStr ]


viewType : String -> String -> List (Html Msg)
viewType moduleName str =
    let
        str_ =
            Regex.replace Regex.All (Regex.regex <| "\\s*" ++ (Regex.escape moduleName) ++ "\\.") (\_ -> "") str

        list =
            str_
                |> String.split "->"
                |> List.foldl
                    (\s ( list, nestLevel ) ->
                        let
                            list_ =
                                if nestLevel == 0 then
                                    s :: list
                                else
                                    (List.head list
                                        |> Maybe.map (\s_ -> s_ ++ " -> " ++ s)
                                        |> Maybe.withDefault s
                                    )
                                        :: (List.tail list |> Maybe.withDefault [])

                            nestLevel_ =
                                if String.contains "(" s then
                                    nestLevel + 1
                                else if String.contains ")" s then
                                    nestLevel - 1
                                else
                                    nestLevel
                        in
                            ( list_, nestLevel_ )
                    )
                    ( [], 0 )
                |> Tuple.first
                |> List.reverse
    in
        if String.length str_ < 64 then
            [ span [] [ text <| " : " ++ String.join " -> " list ] ]
        else
            list
                |> List.indexedMap
                    (\i s ->
                        if i == 0 then
                            div [] [ text <| " : " ++ s ]
                        else
                            div [] [ text <| " -> " ++ s ]
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
