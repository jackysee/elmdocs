port module App exposing (..)

import Html exposing (Html, text, div, input, h1, h3, br, span)
import Html.Attributes exposing (class, style, value, placeholder, id, title, tabindex, classList)
import Html.Events exposing (onClick, onInput, on, keyCode, onWithOptions)
import Http
import String
import String.Extra
import Markdown
import Regex
import Json.Decode
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
    , selectedIndex = 0
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
                , selectedIndex = 0
                , currentDoc =
                    if String.isEmpty text then
                        Nothing
                    else
                        model.currentDoc
                , searchResult =
                    if String.isEmpty text then
                        []
                    else
                        model.searchIndex
                            |> List.filter
                                (\( path, docId ) ->
                                    String.contains
                                        (String.toLower text)
                                        (String.toLower path)
                                )
              }
            , Cmd.none
            )

        SearchPackage text ->
            ( { model | searchPackageText = text }, Cmd.none )

        ToggleShowDisabled ->
            ( { model | showDisabled = not model.showDisabled }, Cmd.none )

        SetShowConfirmDeleteDoc docId ->
            ( { model | showConfirmDeleteDoc = docId }, Cmd.none )

        SetSelectedIndex i ->
            ( { model | selectedIndex = i }, Cmd.none )

        MsgBatch list ->
            List.foldl
                (\msg ( model, cmd ) ->
                    let
                        ( model_, cmd_ ) =
                            update msg model
                    in
                        model_ ! [ cmd, cmd_ ]
                )
                ( model, Cmd.none )
                list


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
                    , on "keyup" <| Json.Decode.map (inputKeyUp model) keyCode
                    ]
                    []
                ]
            , if model.searchText /= "" then
                viewSearchResult model
              else
                div
                    [ class "nav-list" ]
                    [ viewPinnedDocs model
                    , viewDiasabledDocs model
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
                                viewModule model path doc
                            ]
                        ]
                    )
                |> Maybe.withDefault
                    [ div
                        [ class "doc-empty-title" ]
                        [ span [] [ text "ElmDocs" ] ]
                    ]
            )
        ]


inputKeyUp : Model -> Int -> Msg
inputKeyUp model code =
    if code == 40 then
        SetSelectedIndex <|
            if model.searchText == "" then
                min (model.selectedIndex + 1) (List.length model.pinnedDocs - 1)
            else
                min (model.selectedIndex + 1) (List.length model.searchResult - 1)
    else if code == 38 then
        SetSelectedIndex <| max 0 (model.selectedIndex - 1)
    else if code == 13 then
        if model.searchText == "" then
            findFirst
                (\( i, _ ) -> i == model.selectedIndex)
                (List.indexedMap (,) model.pinnedDocs)
                |> Maybe.map (\( i, d ) -> SetCurrentDoc "" d)
                |> Maybe.withDefault NoOp
        else
            findFirst
                (\( i, _ ) -> i == model.selectedIndex)
                (List.indexedMap (,) model.searchResult)
                |> Maybe.map (\( i, ( path, docId ) ) -> GetCurrentDocFromId path docId)
                |> Maybe.withDefault NoOp
    else if code == 27 then
        Search ""
    else
        NoOp


viewSearchResult : Model -> Html Msg
viewSearchResult model =
    if List.length model.searchResult > 0 then
        div [ class "nav-list nav-result" ] <|
            List.indexedMap
                (\i ( path, docId ) ->
                    div
                        [ classList
                            [ ( "nav-item nav-result-item", True )
                            , ( "is-selected", i == model.selectedIndex )
                            ]
                        , onClick <|
                            MsgBatch
                                [ GetCurrentDocFromId path docId
                                , SetSelectedIndex i
                                ]
                        ]
                        [ span
                            [ class "nav-result-path"
                            , title path
                            ]
                            [ text <| path ]
                          {--
                        , span
                            [ class "nav-result-doc" ]
                            [ text
                                (docId
                                    |> String.Extra.rightOf "/"
                                    |> String.Extra.leftOf "#"
                                )
                            ]
                            --}
                        ]
                )
                model.searchResult
    else
        div [ class "nav-list nav-result" ]
            [ div
                [ class "nav-item" ]
                [ text "No result found" ]
            ]


viewPinnedDocs : Model -> Html Msg
viewPinnedDocs model =
    div [ class "nav-pinned" ] <|
        List.indexedMap
            (\i d ->
                div
                    [ classList
                        [ ( "nav-item nav-doc-item", True )
                        , ( "is-selected", i == model.selectedIndex )
                        ]
                    , onClick <|
                        MsgBatch
                            [ SetCurrentDoc "" d
                            , SetSelectedIndex i
                            ]
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
                                    , onClickInside (SetShowConfirmDeleteDoc (Just d.id))
                                    ]
                                    [ span [ class "nav-doc-version-remove-text" ] [ text "Remove" ]
                                    ]
                              else if model.showConfirmDeleteDoc == Just d.id then
                                span
                                    []
                                    [ span
                                        [ class "nav-doc-version-remove-confirm confirm-danger"
                                        , onClickInside (RemoveDoc d)
                                        ]
                                        [ text "Remove" ]
                                    , span
                                        [ class "nav-doc-version-remove-confirm"
                                        , onClickInside (SetShowConfirmDeleteDoc Nothing)
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


viewDiasabledDocs : Model -> Html Msg
viewDiasabledDocs model =
    div
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
                                            , title <| "show " ++ p.name
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


viewModule : Model -> String -> Doc -> Html Msg
viewModule model path doc =
    let
        module_ =
            findFirst (.name >> (==) path) doc.modules
                |> onNothing
                    (doc.modules
                        |> List.filter (\m -> String.startsWith m.name path)
                        |> List.sortBy (\m -> String.length path - String.length m.name)
                        |> List.head
                    )

        moduleNames =
            List.map .name doc.modules

        indexes =
            model.searchIndex
                |> List.filter
                    (\( path, docId ) ->
                        (docId == doc.id)
                            && (not (List.member path moduleNames))
                    )
    in
        case module_ of
            Just m ->
                div
                    [ class "module-doc"
                    , id m.name
                    ]
                    [ h1 []
                        [ span [] [ text m.name ]
                        , div
                            [ class "module-doc-built-with-version" ]
                            [ text <| "Built with Elm " ++ m.generatedWithElmVesion ]
                        ]
                    , div [ class "module-doc-comment" ]
                        (viewModuleComment m.comment m (buildEntryDict m) indexes)
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


onClickInside : Msg -> Html.Attribute Msg
onClickInside msg =
    onWithOptions "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.Decode.succeed msg)


buildEntryDict : Module -> Dict String Entry
buildEntryDict module_ =
    Dict.fromList <|
        List.map (\v -> ( v.name, AliasEntry v )) module_.aliases
            ++ List.map (\v -> ( v.name, ModuleTypeEntry v )) module_.types
            ++ List.map (\v -> ( v.name, ValueEntry v )) module_.values


viewModuleComment : String -> Module -> Dict String Entry -> List ( String, String ) -> List (Html Msg)
viewModuleComment comment module_ entryDict indexes =
    let
        list =
            Regex.split (Regex.AtMost 1) (Regex.regex "@docs") comment
    in
        case list of
            x :: y :: [] ->
                (Markdown.toHtml [] x) :: viewDocs y module_ entryDict indexes

            x :: [] ->
                [ Markdown.toHtml [] x ]

            _ ->
                []


viewDocs : String -> Module -> Dict String Entry -> List ( String, String ) -> List (Html Msg)
viewDocs comment module_ entryDict indexes =
    let
        matches =
            Regex.find
                (Regex.AtMost 1)
                (Regex.regex "^\\s*,?\\s*([^\\s,]*)((?:.|\\r?\\n)*)$")
                comment
                |> List.concatMap .submatches
                |> List.filterMap identity
                |> List.map String.trim
    in
        case matches of
            x :: xs ->
                let
                    x_ =
                        Regex.replace Regex.All (Regex.regex "^\\(|\\)$") (\_ -> "") x
                in
                    case Dict.get x_ entryDict of
                        Just entry ->
                            (viewPart module_.name entry indexes)
                                :: case xs of
                                    y :: [] ->
                                        viewDocs y module_ entryDict indexes

                                    _ ->
                                        []

                        Nothing ->
                            viewModuleComment comment module_ entryDict indexes

            _ ->
                viewModuleComment comment module_ entryDict indexes


viewPart : String -> Entry -> List ( String, String ) -> Html Msg
viewPart moduleName entry indexes =
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
                        , if List.length alias.args > 0 then
                            text <| " " ++ String.join " " alias.args
                          else
                            text ""
                        , text " = "
                        ]
                    , div [ class "indent" ] [ text <| replaceTypesAliasValues indexes alias.type_ ]
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
                    [ span [ class "entry-name" ] [ text <| viewValueEntryName value.name ]
                    , span [ class "value-type " ] <| viewType indexes value.type_
                    ]
                , Markdown.toHtml [ class "entry-comment" ] value.comment
                ]


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


viewValueEntryName : String -> String
viewValueEntryName str =
    if Regex.contains (Regex.regex "^[^a-zA-Z0-9]+$") str then
        "(" ++ str ++ ")"
    else
        str


viewType : List ( String, String ) -> String -> List (Html Msg)
viewType indexes str =
    let
        str_ =
            str
                |> replaceTypesAliasValues indexes
                |> replaceFullPathVar
    in
        if String.length str_ < 64 then
            [ span [] [ text <| " : " ++ str_ ] ]
        else
            str_
                |> splitTypeArgs
                |> List.indexedMap
                    (\i s ->
                        if i == 0 then
                            div [ class "indent" ] [ text <| " : " ++ s ]
                        else
                            div [ class "indent" ] [ text <| " -> " ++ s ]
                    )


splitTypeArgs : String -> List String
splitTypeArgs str =
    let
        result =
            Regex.find
                (Regex.AtMost 1)
                (Regex.regex "^\\s*(?:\\([^\\(\\)]*\\)|{[^{}]*}|[^(->)]*)\\s*->")
                str
    in
        case result of
            { match } :: xs ->
                String.slice 0 (String.length match - 2) match
                    :: (splitTypeArgs <| String.Extra.rightOf match str)

            [] ->
                [ str ]


replaceTypesAliasValues : List ( String, String ) -> String -> String
replaceTypesAliasValues indexes str =
    case indexes of
        [] ->
            str

        ( path, _ ) :: xs ->
            let
                str_ =
                    Regex.replace
                        Regex.All
                        (Regex.regex <| Regex.escape path)
                        (\m -> String.Extra.rightOfBack "." m.match)
                        str
            in
                replaceTypesAliasValues xs str_


replaceFullPathVar : String -> String
replaceFullPathVar str =
    Regex.replace Regex.All
        (Regex.regex "(?:[a-zA-Z0-9_]+\\.)+([a-zA-Z0-9_]+)")
        (\m ->
            m.submatches
                |> List.filterMap identity
                |> List.head
                |> Maybe.withDefault ""
        )
        str


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


port scrollToElement : String -> Cmd msg


port saveLocal : { doc : Doc, searchIndex : List ( String, String ) } -> Cmd msg


port removeLocal : { doc : Doc, searchIndex : List ( String, String ) } -> Cmd msg
