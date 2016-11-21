module App exposing (..)

import Html exposing (Html, text, div, input, h1, h3, br)
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
            Regex.split Regex.All (Regex.regex "@docs [^\\n]*\\n") comment
                |> List.map (Markdown.toHtml [])

        matches =
            Regex.find Regex.All (Regex.regex "@docs ([^\\n]*)\\n") comment

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
                            |> List.map (viewPart module_)
                    )
                |> Debug.log "matches"
    in
        docs


viewPart : Module -> String -> Html Msg
viewPart module_ part =
    case findFirst (\alias -> alias.name == part) module_.aliases of
        Just alias ->
            let
                a =
                    Debug.log "alias" alias
            in
                div []
                    [ h3 [] <|
                        [ text <| "type alias " ++ alias.name ++ " = "
                        , br [] []
                        , text <| alias.type_
                        ]
                            ++ List.map (\arg -> text <| " " ++ arg) alias.args
                    , Markdown.toHtml [] alias.comment
                    ]

        Nothing ->
            text ""


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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
