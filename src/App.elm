port module App exposing (..)

import Html exposing (Html, text, div, input, h1, h3, br, span)
import Html.Attributes exposing (class, style, value, placeholder, id, title, tabindex)
import Html.Events exposing (onClick, onInput)
import Http
import String
import Markdown
import Regex
import Dict exposing (Dict)
import Models exposing (..)
import Decoders exposing (..)
import Msgs exposing (..)


init : Maybe StoreModel -> ( Model, Cmd Msg )
init storeModel =
    { allPackages = []
    , pinnedDocs = storeModel |> Maybe.map .docs |> Maybe.withDefault []
    , currentDoc = Nothing
    , searchIndex = storeModel |> Maybe.map .searchIndex |> Maybe.withDefault []
    , searchResult = []
    , searchText = ""
    , showDisabled = False
    , searchPackageText = ""
    , showConfirmDeleteDoc = Nothing
    }
        ! [ getAllPackages (storeModel == Nothing)
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

        AddDoc p ->
            ( model, getDocs [ p ] )

        RemoveDoc doc ->
            let
                searchIndex =
                    List.filter (\( path, docId ) -> doc.id /= docId) model.searchIndex
                        |> Debug.log "searchIndex"
            in
                { model
                    | pinnedDocs = List.filter ((/=) doc) model.pinnedDocs
                    , searchIndex = searchIndex
                    , showConfirmDeleteDoc = Nothing
                }
                    ! [ removeLocal { doc = doc, searchIndex = searchIndex } ]

        PinDoc rest (Ok doc) ->
            let
                searchIndex =
                    buildSearchIndex model.searchIndex doc
            in
                { model
                    | pinnedDocs = model.pinnedDocs ++ [ doc ]
                    , searchIndex = searchIndex
                }
                    ! [ getDocs rest
                      , saveLocal { doc = doc, searchIndex = searchIndex }
                      ]

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

        GetCurrentDocFromId nav docId ->
            case String.split "#" docId of
                name :: version :: [] ->
                    ( { model
                        | currentDoc =
                            findFirst
                                (\doc ->
                                    doc.packageName == name && doc.packageVersion == version
                                )
                                model.pinnedDocs
                                |> Maybe.map (\doc -> ( nav, doc ))
                      }
                    , scrollToElement nav
                    )

                _ ->
                    ( model, Cmd.none )

        SetCurrentDoc nav doc ->
            ( { model | currentDoc = Just ( nav, doc ) }
            , scrollToElement nav
            )

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

        SearchPackage text ->
            ( { model | searchPackageText = text }, Cmd.none )

        ToggleShowDisabled ->
            ( { model | showDisabled = not model.showDisabled }, Cmd.none )

        SetShowConfirmDeleteDoc docId ->
            ( { model | showConfirmDeleteDoc = docId }, Cmd.none )


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
                                    , onClick (GetCurrentDocFromId path docId)
                                    ]
                                    [ text <| path ]
                            )
                            model.searchResult
                else
                    div [ class "nav-list nav-result" ]
                        [ div
                            [ class "nav-item" ]
                            [ text "No result found" ]
                        ]
              else
                div
                    [ class "nav-list" ]
                    [ div [ class "nav-pinned" ] <|
                        List.map
                            (\d ->
                                div
                                    [ class "nav-item nav-doc-item"
                                    , onClick (SetCurrentDoc "" d)
                                    ]
                                    [ span [ class "nav-doc-package" ] [ text d.packageName ]
                                    , span [ class "nav-doc-version" ]
                                        [ div
                                            [ class "nav-doc-version-str" ]
                                            [ text d.packageVersion ]
                                        , div [ class "nav-doc-version-action" ]
                                            [ if model.showConfirmDeleteDoc == Nothing then
                                                span
                                                    [ class "nav-doc-version-remove"
                                                    , onClick (SetShowConfirmDeleteDoc (Just d.id))
                                                    ]
                                                    [ span [ class "nav-doc-version-remove-text" ] [ text "Remove" ]
                                                    ]
                                              else if model.showConfirmDeleteDoc == Just d.id then
                                                span
                                                    []
                                                    [ span
                                                        [ class "nav-doc-version-remove-confirm confirm-danger"
                                                        , onClick (RemoveDoc d)
                                                        ]
                                                        [ text "Remove" ]
                                                    , span
                                                        [ class "nav-doc-version-remove-confirm"
                                                        , onClick (SetShowConfirmDeleteDoc Nothing)
                                                        ]
                                                        [ text "/ Cancel" ]
                                                    ]
                                              else
                                                text ""
                                            ]
                                        ]
                                    ]
                            )
                            model.pinnedDocs
                    , div
                        [ class "nav-packages nav-item" ]
                        [ div
                            [ onClick ToggleShowDisabled ]
                            [ text <| "Disabled" ]
                        , if model.showDisabled then
                            div [] <|
                                [ div [ class "nav-item nav-package-search" ]
                                    [ input
                                        [ class "search-package-input"
                                        , value model.searchPackageText
                                        , onInput SearchPackage
                                        , placeholder "Search Package"
                                        ]
                                        []
                                    ]
                                ]
                                    ++ (model.allPackages
                                            |> List.filter
                                                (\p ->
                                                    (not <| List.member p.name (List.map .packageName model.pinnedDocs))
                                                        && if model.searchPackageText /= "" then
                                                            String.contains
                                                                (String.toLower model.searchPackageText)
                                                                (String.toLower p.name)
                                                           else
                                                            True
                                                )
                                            |> List.map
                                                (\p ->
                                                    div
                                                        [ class "nav-item nav-doc-item"
                                                        ]
                                                        [ span
                                                            [ class "nav-doc-package"
                                                            , title "show doc"
                                                            , onClick (GetCurrentDocFromPackage p)
                                                            ]
                                                            [ text p.name ]
                                                        , span
                                                            [ class "nav-doc-version" ]
                                                          <|
                                                            case List.head p.versions of
                                                                Just version_ ->
                                                                    [ span
                                                                        [ class "nav-doc-version-str" ]
                                                                        [ text version_ ]
                                                                    , span
                                                                        [ class "nav-doc-version-action"
                                                                        , title "add to search index"
                                                                        , onClick (AddDoc ( p.name, version_ ))
                                                                        ]
                                                                        [ text "Add" ]
                                                                    ]

                                                                Nothing ->
                                                                    []
                                                        ]
                                                )
                                       )
                          else
                            text ""
                        ]
                    ]
            ]
        , div [ class "doc" ]
            (model.currentDoc
                |> Maybe.map
                    (\( path, doc ) ->
                        [ h1
                            [ class "doc-title" ]
                            [ text <| doc.packageName ++ "/" ++ doc.packageVersion ]
                        , div [ class "doc-content" ]
                            [ if path == "" then
                                viewDocOverview doc
                              else
                                viewModule path doc
                            ]
                        ]
                    )
                |> Maybe.withDefault []
            )
        ]


viewDocOverview : Doc -> Html Msg
viewDocOverview doc =
    div
        [ class "doc-overview" ]
    <|
        [ h1 [] [ text <| doc.packageName ++ "/" ++ doc.packageVersion ] ]
            ++ (doc.modules
                    |> List.sortBy .name
                    |> List.map
                        (\m ->
                            div
                                [ class "module-link"
                                , onClick (SetCurrentDoc m.name doc)
                                ]
                                [ text m.name ]
                        )
               )


viewModule : String -> Doc -> Html Msg
viewModule path doc =
    let
        module_ =
            findFirst (.name >> (==) path) doc.modules
                |> onNothing (findFirst (\m -> String.startsWith m.name path) doc.modules)
    in
        case module_ of
            Just m ->
                div
                    [ class "module-doc"
                    , id m.name
                    ]
                    [ h1 [] [ text <| m.name ]
                    , div [ class "module-doc-comment" ] <| viewModuleComment m.comment m
                    ]

            Nothing ->
                div [] [ text "module not found." ]


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


viewModuleComment : String -> Module -> List (Html Msg)
viewModuleComment comment module_ =
    let
        docs =
            Regex.split Regex.All (Regex.regex "@docs [^#]*") comment
                |> List.map (Markdown.toHtml [])

        matches =
            Regex.find Regex.All (Regex.regex "@docs ([^#]*)") comment

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
                            |> List.map String.trim
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
                    div
                        [ class "entry"
                        , id <| moduleName ++ "." ++ alias.name
                        ]
                        [ h3 [] <|
                            [ div []
                                [ text "type alias "
                                , span [ class "entry-name" ] [ text alias.name ]
                                , text " = "
                                ]
                            , div [ class "indent" ] [ text <| alias.type_ ]
                            , if List.length alias.args > 0 then
                                div [ class "indent" ] [ text <| String.join " " alias.args ]
                              else
                                text ""
                            ]
                        , Markdown.toHtml [ class "entry-comment" ] alias.comment
                        ]

                ModuleTypeEntry tipe ->
                    div
                        [ class "entry"
                        , id <| moduleName ++ "." ++ tipe.name
                        ]
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
                    div
                        [ class "entry"
                        , id <| moduleName ++ "." ++ value.name
                        ]
                        [ h3 [] <|
                            [ span [ class "entry-name" ] [ text value.name ]
                            , span [ class "value-type " ] <| viewType moduleName value.type_
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
        div [ class "indent" ] [ text caseStr ]


viewType : String -> String -> List (Html Msg)
viewType moduleName str =
    let
        str_ =
            Regex.replace Regex.All (Regex.regex <| (Regex.escape moduleName) ++ "\\.") (\_ -> "") str
    in
        if String.length str_ < 64 then
            [ span [] [ text <| " : " ++ str_ ] ]
        else
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
                |> List.indexedMap
                    (\i s ->
                        if i == 0 then
                            div [ class "indent" ] [ text <| " : " ++ s ]
                        else
                            div [ class "indent" ] [ text <| " -> " ++ s ]
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


port scrollToElement : String -> Cmd msg


port saveLocal : { doc : Doc, searchIndex : List ( String, String ) } -> Cmd msg


port removeLocal : { doc : Doc, searchIndex : List ( String, String ) } -> Cmd msg
