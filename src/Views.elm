module Views exposing (view)

import Html exposing (Html, text, div, input, h1, h2, h3, br, span, button, a)
import Html.Attributes exposing (class, style, value, placeholder, id, title, tabindex, classList, href, target, autofocus)
import Html.Events exposing (onClick, onInput, on, keyCode, onWithOptions, onFocus, onBlur)
import String
import String.Extra
import Markdown
import Regex
import Json.Decode
import Dict exposing (Dict)
import Models exposing (..)
import Msgs exposing (..)
import Icons
import Utils exposing (..)
import Mouse


view : Model -> Html Msg
view model =
    div
        [ class "main" ]
        [ div
            [ class "nav"
            , style [ ( "width", (toString model.navWidth) ++ "px" ) ]
            ]
            [ div [ class "nav-top " ]
                [ input
                    [ class "search-input"
                    , onInput Search
                    , value model.searchText
                    , placeholder "Search..."
                    , id "search-input"
                    , onFocus (SetSearchFocused True)
                    , onBlur (SetSearchFocused False)
                    ]
                    []
                ]
            , if model.searchText /= "" then
                viewSearchResult model
              else
                navList model
            ]
        , div
            [ class "doc" ]
          <|
            [ div
                [ class "nav-drag-handle"
                , on "mousedown" (Json.Decode.map DragStart Mouse.position)
                ]
                []
            ]
                ++ case model.page of
                    Home ->
                        [ div
                            [ class "doc-empty-title" ]
                            [ span [] [ text "ElmDocs" ]
                            , Markdown.toHtml
                                [ class "doc-info" ]
                                """[elmdocs](http://github.com/jackysee/elmdocs) is written in [Elm](http://elm-lang.org) by [jackysee](http://twitter.com/jackysee)."""
                            ]
                        ]

                    DocOverview docId ->
                        case getDocById model docId of
                            Just doc ->
                                [ docTitle model doc False
                                , div
                                    [ class "doc-content" ]
                                    [ viewDocOverview doc False ]
                                ]

                            Nothing ->
                                []

                    DocModule docId modulePath ->
                        case getDocById model docId of
                            Just doc ->
                                [ docTitle model doc False
                                , div
                                    [ class "doc-content" ]
                                    [ viewModule model modulePath doc ]
                                ]

                            Nothing ->
                                []

                    DisabledDoc doc modulePath ->
                        [ docTitle model doc True
                        , div
                            [ class "doc-content" ]
                          <|
                            [ div [ class "doc-disabled-info" ]
                                [ text "This documentation is disabled."
                                , button
                                    [ class "btn-link"
                                    , onClick <|
                                        MsgBatch
                                            [ PinDoc [] (Ok doc)
                                            , LinkToPinnedDoc modulePath doc.id
                                            ]
                                    ]
                                    [ text "Enable it" ]
                                ]
                            , if modulePath == "" then
                                viewDocOverview doc True
                              else
                                viewModule model modulePath doc
                            ]
                        ]

                    NotFound ->
                        [ div
                            [ class "doc-empty-title" ]
                            [ span [] [ text "Document not found" ] ]
                        ]

                    Loading ->
                        [ div
                            [ class "doc-empty-title" ]
                            [ span [] [ text "Loading" ] ]
                        ]
        ]


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
                                [ LinkToPinnedDoc path docId
                                , SetSelectedIndex i
                                ]
                        , id <| "item-" ++ toString i
                        ]
                        [ span
                            [ class "nav-result-path"
                            , title path
                            ]
                            [ text <| path ]
                        , if hasDuplicate (\( path_, docId ) -> path_ == path) model.searchResult then
                            span
                                [ class "nav-result-doc" ]
                                [ text <| String.Extra.rightOfBack "/" docId ]
                          else
                            text ""
                        ]
                )
                model.searchResult
    else
        div [ class "nav-list nav-result" ]
            [ div
                [ class "nav-item" ]
                [ text "No result found" ]
            ]


navList : Model -> Html Msg
navList model =
    div [ class "nav-list" ] <|
        List.indexedMap (viewNavItem model) model.navList


viewNavItem : Model -> Int -> DocNavItem -> Html Msg
viewNavItem model i navItem =
    case navItem of
        DocNav d ->
            div
                [ classList
                    [ ( "nav-item nav-doc-item", True )
                    , ( "is-selected", i == model.selectedIndex )
                    ]
                , onClick <|
                    MsgBatch
                        [ LinkToPinnedDoc "" d.id
                        , SetSelectedIndex i
                        ]
                , id <| "item-" ++ toString i
                ]
                [ span
                    [ class "icon"
                    , onClickInside (DocNavExpand (not d.navExpanded) d.id)
                    ]
                    [ if d.navExpanded then
                        Icons.caretDown
                      else
                        Icons.caretRight
                    ]
                , span [ class "nav-doc-package" ] [ text d.packageName ]
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
                                [ span
                                    [ class "nav-doc-version-remove-text btn-link" ]
                                    [ text "Remove" ]
                                ]
                          else if model.showConfirmDeleteDoc == Just d.id then
                            span
                                []
                                [ span
                                    [ class "nav-doc-version-remove-confirm btn-link confirm-danger"
                                    , onClickInside (RemoveDoc d)
                                    ]
                                    [ text "Remove" ]
                                , span
                                    [ class "nav-doc-version-remove-confirm btn-link"
                                    , onClickInside (SetShowConfirmDeleteDoc Nothing)
                                    ]
                                    [ text "/ Cancel" ]
                                ]
                          else
                            text ""
                        ]
                    ]
                ]

        ModuleNav m docId ->
            div
                [ classList
                    [ ( "nav-item nav-doc-module", True )
                    , ( "is-selected", i == model.selectedIndex )
                    ]
                , onClick <|
                    MsgBatch
                        [ LinkToPinnedDoc m.name docId
                        , SetSelectedIndex i
                        ]
                , id <| "item-" ++ toString i
                ]
                [ span [] [ text m.name ] ]

        DisabledHandleNav ->
            div
                [ classList
                    [ ( "nav-item nav-packages-disabled-handle", True )
                    , ( "is-selected", i == model.selectedIndex )
                    ]
                , onClick (SetShowDisabled <| not model.showDisabled)
                , id <| "item-" ++ toString i
                ]
                [ span
                    [ class "icon" ]
                    [ if model.showDisabled then
                        Icons.caretDown
                      else
                        Icons.caretRight
                    ]
                , span
                    [ class "flex-wide" ]
                    [ text <| "Disabled (" ++ (disabledPackages model |> List.length |> toString) ++ ")"
                    ]
                , if model.showDisabled then
                    div []
                        [ span
                            [ classList
                                [ ( "btn-pill", True )
                                , ( "is-selected", model.showNewOnly )
                                ]
                            , onClickInside (SetShowNewOnly True)
                            ]
                            [ text ".18" ]
                        , span
                            [ classList
                                [ ( "btn-pill", True )
                                , ( "is-selected", not model.showNewOnly )
                                ]
                            , onClickInside (SetShowNewOnly False)
                            ]
                            [ text "all" ]
                        ]
                  else
                    text ""
                ]

        DisabledInputNav ->
            div
                [ classList
                    [ ( "nav-item nav-package-search", True )
                    , ( "is-selected", i == model.selectedIndex )
                    ]
                , id <| "item-" ++ toString i
                ]
                [ input
                    [ class "search-package-input"
                    , value model.searchPackageText
                    , onInput SearchPackage
                    , placeholder "Search Package..."
                    , id "package-search-input"
                    ]
                    []
                ]

        DisabledDocNav p ->
            div
                [ classList
                    [ ( "nav-item nav-doc-item nav-packages-doc-item", True )
                    , ( "is-selected", i == model.selectedIndex )
                    ]
                , id <| "item-" ++ toString i
                ]
                [ if List.length p.versions > 1 then
                    span
                        [ class "icon"
                        , onClickInside <|
                            MsgBatch
                                [ DisabledDocNavExpand (not p.versionExpanded) p
                                , SetSelectedIndex i
                                ]
                        ]
                        [ if p.versionExpanded then
                            Icons.caretDown
                          else
                            Icons.caretRight
                        ]
                  else
                    span [ class "no-icon" ] []
                , span
                    [ class "nav-doc-package"
                    , title <| "show " ++ p.name
                    , case List.head p.versions of
                        Just version ->
                            onClick <|
                                MsgBatch
                                    [ LinkToDisabledDoc p.name version ""
                                    , SetSelectedIndex i
                                    ]

                        Nothing ->
                            onClick NoOp
                    ]
                    [ text p.name ]
                , span [ class "nav-doc-version" ] <|
                    if p.versionExpanded then
                        []
                    else
                        case List.head p.versions of
                            Just version_ ->
                                [ span
                                    [ class "nav-doc-version-str" ]
                                    [ text version_ ]
                                , if model.addDocState == AddDocLoading ( p.name, version_ ) then
                                    text "...loading"
                                  else
                                    span
                                        [ class "nav-doc-version-action btn-link"
                                        , title "add to search index"
                                        , onClick <| AddDoc ( p.name, version_ )
                                        ]
                                        [ text "Add" ]
                                ]

                            Nothing ->
                                []
                ]

        DisabledDocOtherVersionNav p version ->
            let
                available =
                    List.any ((==) version) p.availableVersions

                remoteUrl =
                    "http://package.elm-lang.org/packages/" ++ p.name ++ "/" ++ version
            in
                div
                    [ classList
                        [ ( "nav-item nav-doc-item nav-packages-doc-item nav-packages-doc-other-version", True )
                        , ( "is-selected", i == model.selectedIndex )
                        ]
                    , id <| "item-" ++ toString i
                    , if not available then
                        onClick (OpenRemoteLink remoteUrl)
                      else
                        onClick NoOp
                    ]
                <|
                    if available then
                        [ span
                            [ class "nav-doc-package"
                            , title <| "show " ++ p.name
                            , onClick <|
                                MsgBatch
                                    [ LinkToDisabledDoc p.name version ""
                                    , SetSelectedIndex i
                                    ]
                            ]
                            [ text version ]
                        , span [ class "nav-doc-version" ] <|
                            [ if model.addDocState == AddDocLoading ( p.name, version ) then
                                text "...loading"
                              else
                                span
                                    [ class "btn-link"
                                    , title "add to search index"
                                    , onClick <| AddDoc ( p.name, version )
                                    ]
                                    [ text "Add" ]
                            ]
                        ]
                    else
                        [ remoteLink remoteUrl
                            [ text version
                            , span [ class "btn-link-icon" ] [ Icons.externalLink ]
                            ]
                        ]


viewDocOverview : Doc -> Bool -> Html Msg
viewDocOverview doc disabled =
    let
        listModules =
            doc.modules
                |> List.sortBy .name
                |> List.map
                    (\m ->
                        div []
                            [ div
                                [ class "btn-link"
                                , if disabled then
                                    onClick (LinkToDisabledDoc doc.packageName doc.packageVersion m.name)
                                  else
                                    onClick (LinkToModule m.name)
                                ]
                                [ text m.name ]
                            ]
                    )
    in
        if String.isEmpty doc.readme then
            div [ class "doc-overview-no-readme" ] <|
                [ h1 [] [ text <| doc.packageName ++ "/" ++ doc.packageVersion ] ]
                    ++ listModules
        else
            div [ class "doc-overview" ] <|
                [ block
                    [ class "doc-overview-readme" ]
                    doc.readme
                , div [ class "doc-overview-modules" ]
                    listModules
                ]


docTitle : Model -> Doc -> Bool -> Html Msg
docTitle model doc disabled =
    h1
        [ class "doc-title" ]
        [ div []
            [ span
                [ class "btn-link"
                , if disabled then
                    onClick (LinkToDisabledDoc doc.packageName doc.packageVersion "")
                  else
                    onClick (LinkToPinnedDoc "" doc.id)
                ]
                [ text <| doc.packageName ++ "/" ++ doc.packageVersion ]
            , case getLatestVerByDocId model doc.id of
                Just ver ->
                    if ver /= doc.packageVersion then
                        span [ class "doc-title-latest" ]
                            [ text "(latest "
                            , span
                                [ class "btn-link"
                                , if isPinned model doc.packageName ver then
                                    onClick (LinkToPinnedDoc "" (doc.packageName ++ "/" ++ ver))
                                  else
                                    onClick (LinkToDisabledDoc doc.packageName ver "")
                                ]
                                [ text ver ]
                            , text ")"
                            ]
                    else
                        text ""

                Nothing ->
                    text ""
            ]
        , div
            []
            [ remoteLink
                ("http://package.elm-lang.org/packages/" ++ doc.packageName ++ "/" ++ doc.packageVersion)
                [ text "elm packages"
                , span [ class "btn-link-icon" ] [ Icons.externalLink ]
                ]
            , remoteLink
                ("https://github.com/" ++ doc.packageName)
                [ text "Browse Source"
                , span [ class "btn-link-icon" ] [ Icons.externalLink ]
                ]
            ]
        ]


remoteLink : String -> List (Html Msg) -> Html Msg
remoteLink url label =
    a
        [ class "btn-link"
        , href url
        , target "_blank"
        , onWithOptions "click"
            { stopPropagation = True
            , preventDefault = False
            }
            (Json.Decode.succeed NoOp)
        ]
        label


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
                text ""


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
                (block [] x) :: viewDocs y module_ entryDict indexes

            x :: [] ->
                [ block [] x ]

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
                    [ div [] <|
                        [ text "type alias "
                        , span
                            [ class "entry-name btn-link"
                            , onClick (LinkToModule <| moduleName ++ "." ++ alias.name)
                            ]
                            [ text alias.name ]
                        ]
                            ++ (if List.length alias.args > 0 then
                                    (" " ++ String.join " " alias.args)
                                        |> linkToName indexes
                                else
                                    []
                               )
                            ++ [ text " = " ]
                    , div [ class "indent" ] <|
                        linkToName indexes alias.type_
                    ]
                , block [ class "entry-comment" ] alias.comment
                ]

        ModuleTypeEntry tipe ->
            div
                [ class "entry"
                , id <| moduleName ++ "." ++ tipe.name
                ]
            <|
                (List.map
                    (\( c, _ ) ->
                        span [ id <| moduleName ++ "." ++ tipe.name ++ "-" ++ c ] []
                    )
                    tipe.cases
                )
                    ++ [ h3 [] <|
                            [ text "type "
                            , span
                                [ class "btn-link entry-name"
                                , onClick (LinkToModule <| moduleName ++ "." ++ tipe.name)
                                ]
                                [ text tipe.name ]
                            ]
                                ++ ((" " ++ String.join " " tipe.args) |> linkToName indexes)
                                ++ (if List.length tipe.cases > 0 then
                                        tipe.cases |> List.indexedMap viewCase
                                    else
                                        [ text "" ]
                                   )
                       , block [ class "entry-comment" ] tipe.comment
                       ]

        ValueEntry value ->
            div
                [ class "entry"
                , id <| moduleName ++ "." ++ value.name
                ]
                [ h3 [] <|
                    [ span
                        [ class "entry-name btn-link"
                        , onClick (LinkToModule <| moduleName ++ "." ++ value.name)
                        ]
                        [ text <| viewValueEntryName value.name ]
                    , span [ class "value-type " ] <|
                        viewType indexes value.type_
                    ]
                , block [ class "entry-comment" ] value.comment
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
            [ prefix, case_, String.join " " caseArgs ]
                |> String.join " "
    in
        div [ class "indent" ]
            [ text caseStr ]


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
            replaceFullPathVar str
    in
        if String.length str_ < 64 then
            [ span [] [ text " : " ] ]
                ++ linkToName indexes str
        else
            str
                |> splitTypeArgs
                |> List.indexedMap
                    (\i s ->
                        if i == 0 then
                            div [ class "indent" ] <|
                                [ span [] [ text " : " ] ]
                                    ++ linkToName indexes s
                        else
                            div [ class "indent" ] <|
                                [ span [] [ text " -> " ] ]
                                    ++ linkToName indexes s
                    )


linkToName : List ( String, String ) -> String -> List (Html Msg)
linkToName indexes str =
    let
        matches =
            findNameMatches indexes str |> List.sortBy .index

        replace =
            \index matches str ->
                case matches of
                    [] ->
                        [ span []
                            [ String.slice index (String.length str) str
                                |> replaceFullPathVar
                                |> text
                            ]
                        ]

                    x :: xs ->
                        let
                            txt =
                                String.slice index x.index str
                                    |> (\txt ->
                                            if txt == "" then
                                                Nothing
                                            else
                                                Just <| span [] [ text <| replaceFullPathVar txt ]
                                       )

                            name =
                                String.slice x.index (x.index + String.length x.match) str
                                    |> (\name ->
                                            Just <|
                                                span
                                                    [ class "btn-link"
                                                    , title name
                                                    , onClick (LinkToModule name)
                                                    ]
                                                    [ text <| String.Extra.rightOfBack "." name ]
                                       )

                            parts =
                                [ txt, name ] |> List.filterMap identity
                        in
                            parts ++ (replace (x.index + String.length x.match) xs str)
    in
        replace 0 matches str


findNameMatches : List ( String, String ) -> String -> List Regex.Match
findNameMatches indexes str =
    case indexes of
        [] ->
            []

        ( path, _ ) :: xs ->
            let
                matches =
                    Regex.find
                        Regex.All
                        (Regex.regex (Regex.escape path ++ "(:?\\s+|$)"))
                        str
                        |> List.map
                            (\match ->
                                { match | match = String.trim match.match }
                            )
            in
                matches ++ findNameMatches xs str


splitTypeArgs : String -> List String
splitTypeArgs str =
    let
        find =
            \atMost str ->
                let
                    matches =
                        Regex.find (Regex.AtMost atMost) (Regex.regex "->") str

                    match_ =
                        if List.length matches == atMost then
                            matches |> List.reverse |> List.head
                        else
                            Nothing
                in
                    case match_ of
                        Just match ->
                            let
                                s1 =
                                    String.slice 0 match.index str

                                s2 =
                                    String.slice (match.index + 2) (String.length str) str
                            in
                                if isBracketBalanced "(" ")" s1 && isBracketBalanced "{" "}" s1 then
                                    Just ( s1, s2 )
                                else
                                    find (atMost + 1) str

                        Nothing ->
                            Nothing
    in
        case find 1 str of
            Just ( s1, s2 ) ->
                s1 :: (splitTypeArgs s2)

            Nothing ->
                [ str ]


isBracketBalanced : String -> String -> String -> Bool
isBracketBalanced open end str =
    if String.contains open str || String.contains end str then
        String.Extra.countOccurrences open str == String.Extra.countOccurrences end str
    else
        True


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


block : List (Html.Attribute Msg) -> String -> Html Msg
block list str =
    let
        options =
            Markdown.defaultOptions
    in
        Markdown.toHtmlWith
            { options | defaultHighlighting = Just "elm" }
            list
            str
