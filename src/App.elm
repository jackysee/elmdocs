port module App exposing (..)

import Http
import String
import Regex
import Json.Decode
import Task exposing (Task)
import Navigation exposing (Location)
import Models exposing (..)
import Decoders exposing (..)
import Msgs exposing (..)
import Utils exposing (..)
import Navigation
import Mouse
import Dom
import Return exposing (Return)
import Keys


init : Maybe Json.Decode.Value -> Location -> ( Model, Cmd Msg )
init value location =
    let
        storeModel =
            value
                |> Maybe.map
                    (\value_ ->
                        Json.Decode.decodeValue decodeStoreModel value_
                            |> Result.withDefault defaultStoreModel
                    )
                |> Maybe.withDefault defaultStoreModel

        model =
            updateNavList
                { allPackages = []
                , newPackages = []
                , pinnedDocs = sortDocs storeModel.docs
                , navList = []
                , page = Home
                , searchIndex = storeModel.searchIndex
                , searchResult = []
                , searchText = ""
                , searchFocused = False
                , showDisabled = False
                , showNewOnly = True
                , searchPackageText = ""
                , showConfirmDeleteDoc = Nothing
                , selectedIndex = 0
                , navWidth = storeModel.navWidth
                , drag = Nothing
                , addDocState = AddDocIdle
                }
    in
        model ! [ getAllPackages (value == Nothing) location ]


sortDocs : List Doc -> List Doc
sortDocs docs =
    --List.sortBy .packageName docs
    List.sortWith biasedSort docs


biasedSort : Doc -> Doc -> Order
biasedSort docA docB =
    case ( toBias docA, toBias docB ) of
        ( Lang a_, Lang b_ ) ->
            compare a_ b_

        ( Lang _, _ ) ->
            LT

        ( _, Lang b ) ->
            GT

        ( Community a_, Community b_ ) ->
            compare a_ b_

        ( Community _, _ ) ->
            LT

        ( _, Community _ ) ->
            GT

        ( Other a_, Other b_ ) ->
            compare a_ b_


toBias : Doc -> Bias
toBias doc =
    bias <| String.toLower doc.packageName


bias : String -> Bias
bias str =
    if String.startsWith "elm-lang" str then
        Lang str
    else if String.startsWith "elm-community" str then
        Community str
    else
        Other str


type Bias
    = Lang String
    | Community String
    | Other String


getAllPackages : Bool -> Location -> Cmd Msg
getAllPackages loadDefault location =
    Task.map2
        (,)
        (Http.get "json/all-packages.json" decodeAllPackages |> Http.toTask)
        (Http.get "json/new-packages.json" decodeNewPackages |> Http.toTask)
        |> Task.attempt (LoadAllPackages loadDefault location)


getDoc : String -> String -> Task Http.Error Doc
getDoc moduleName version =
    Task.map2
        (\doc readme -> { doc | readme = readme })
        (Http.get
            ("json/packages/" ++ moduleName ++ "/" ++ version ++ "/documentation.json")
            (decodeDoc moduleName version)
            |> Http.toTask
        )
        (Http.getString
            ("json/packages/" ++ moduleName ++ "/" ++ version ++ "/README.md")
            |> Http.toTask
            |> Task.onError (\_ -> Task.succeed "")
        )


getDocs : List ( String, String ) -> Cmd Msg
getDocs list =
    case list of
        ( moduleName, version ) :: xs ->
            getDoc moduleName version
                |> Task.attempt (PinDoc xs)

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
        aliasesName m =
            List.map .name m.aliases

        typesName m =
            List.concatMap
                (\m ->
                    [ m.name ]
                        ++ List.map (\( name, _ ) -> m.name ++ " " ++ name) m.cases
                )
                m.types

        valuesName m =
            List.map .name m.values
    in
        list
            ++ (doc.modules
                    |> List.concatMap
                        (\m ->
                            [ m.name ]
                                ++ List.map
                                    (\name -> m.name ++ "." ++ name)
                                    (aliasesName m
                                        ++ typesName m
                                        ++ valuesName m
                                    )
                        )
                    |> List.map (\path -> ( path, doc.id ))
               )


update : Msg -> Model -> Return Msg Model
update msg model =
    case msg of
        NoOp ->
            Return.singleton model

        MsgBatch list ->
            List.foldl
                Return.andThen
                (Return.singleton model)
                (List.map update list)

        LoadAllPackages loadDefault location (Ok ( allPackages, newPackages )) ->
            { model
                | allPackages = allPackages
                , newPackages = newPackages
            }
                |> Return.singleton
                |> Return.map updateNavList
                |> Return.effect_
                    (\model_ ->
                        if loadDefault then
                            getDefaultDocs model_
                        else
                            Navigation.newUrl location.hash
                    )
                |> Return.command (focus "search-input")

        LoadAllPackages loadDefault location (Err err) ->
            let
                a =
                    Debug.log "error loading all packages" err
            in
                Return.singleton model

        AddDoc p ->
            { model | addDocState = AddDocLoading p }
                |> Return.singleton
                |> Return.command (getDocs [ p ])

        RemoveDoc doc ->
            { model
                | pinnedDocs = List.filter ((/=) doc) model.pinnedDocs
                , searchIndex =
                    List.filter (\( path, docId ) -> doc.id /= docId) model.searchIndex
                , showConfirmDeleteDoc = Nothing
                , page = Home
            }
                |> Return.singleton
                |> Return.map updateNavList
                |> Return.effect_
                    (\{ searchIndex } ->
                        removeLocal { doc = doc, searchIndex = searchIndex }
                    )

        PinDoc rest (Ok doc) ->
            { model
                | pinnedDocs = sortDocs <| doc :: model.pinnedDocs
                , searchIndex =
                    buildSearchIndex
                        model.searchIndex
                        doc
                , addDocState = AddDocIdle
            }
                |> Return.singleton
                |> Return.map updateNavList
                |> Return.command (getDocs rest)
                |> Return.effect_
                    (\{ searchIndex } ->
                        saveLocal { doc = doc, searchIndex = searchIndex }
                    )

        PinDoc rest (Err err) ->
            { model | addDocState = AddDocIdle }
                |> Return.singleton
                |> Return.command (getDocs rest)

        GetCurrentDocFromPackage name version modulePath ->
            Return.singleton model
                |> Return.map
                    (\model ->
                        case model.page of
                            DisabledDoc doc _ ->
                                if doc.id == name ++ "/" ++ version then
                                    { model | page = DisabledDoc doc modulePath }
                                else
                                    { model | page = Loading }

                            _ ->
                                { model | page = Loading }
                    )
                |> Return.effect_
                    (\{ page } ->
                        if page == Loading then
                            getDoc name version
                                |> Task.attempt
                                    (Result.map
                                        (\doc ->
                                            SetDisabledDoc doc modulePath
                                        )
                                        >> Result.withDefault NoOp
                                    )
                        else
                            Cmd.none
                    )

        SetDisabledDoc doc path ->
            Return.singleton { model | page = DisabledDoc doc path }

        SetDisabledDocModule modulePath ->
            case model.page of
                DisabledDoc doc _ ->
                    Return.singleton { model | page = DisabledDoc doc modulePath }

                _ ->
                    Return.singleton model

        SetCurrentDocFromId modulePath docId ->
            { model
                | page =
                    if docId == "" then
                        Home
                    else
                        case getDocById model docId of
                            Just doc ->
                                if modulePath == "" then
                                    DocOverview doc.id
                                else
                                    DocModule doc.id modulePath

                            Nothing ->
                                NotFound
            }
                |> Return.singleton
                |> Return.command
                    (modulePath
                        |> Regex.replace Regex.All (Regex.regex "%20") (\_ -> "-")
                        |> Http.decodeUri
                        |> Maybe.withDefault modulePath
                        |> scrollToElement
                    )

        Search text ->
            { model
                | searchText = text
                , selectedIndex = 0
                , page =
                    if String.isEmpty text then
                        Home
                    else
                        model.page
                , searchResult =
                    if String.isEmpty text then
                        []
                    else
                        model.searchIndex
                            |> List.filter
                                (\( pathId, docId ) ->
                                    if Regex.contains (Regex.regex "^\\.*$") text then
                                        False
                                    else
                                        simpleMatch text pathId
                                )
                            |> List.sortBy
                                (\( pathId, docId ) ->
                                    sortPath "." text pathId
                                )
            }
                |> Return.singleton
                |> Return.map updateNavList

        SearchPackage text ->
            { model | searchPackageText = text }
                |> Return.singleton
                |> Return.map updateNavList

        SetShowDisabled show ->
            { model
                | showDisabled = show
                , selectedIndex =
                    if show then
                        model.selectedIndex
                    else
                        model.navList
                            |> findIndex (\n -> n == DisabledHandleNav)
                            |> Maybe.withDefault model.selectedIndex
            }
                |> Return.singleton
                |> Return.map updateNavList
                |> Return.effect_
                    (\{ selectedIndex } ->
                        listScrollTo <| "item-" ++ toString selectedIndex
                    )

        SetShowNewOnly show ->
            Return.singleton <| updateNavList { model | showNewOnly = show }

        SetShowConfirmDeleteDoc docId ->
            Return.singleton { model | showConfirmDeleteDoc = docId }

        SetSelectedIndex i ->
            Return.singleton { model | selectedIndex = i }

        DocNavExpand expand docId ->
            { model
                | pinnedDocs =
                    List.map
                        (\d ->
                            if d.id == docId then
                                { d | navExpanded = expand }
                            else
                                d
                        )
                        model.pinnedDocs
                , selectedIndex =
                    model.navList
                        |> findIndex
                            (\navItem ->
                                case navItem of
                                    DocNav d ->
                                        d.id == docId

                                    _ ->
                                        False
                            )
                        |> Maybe.withDefault 0
            }
                |> Return.singleton
                |> Return.map updateNavList

        LinkToPinnedDoc path docId ->
            Return.singleton model
                |> Return.command (Navigation.newUrl <| "#local/" ++ docId ++ "/" ++ path)

        LinkToDisabledDoc name version path ->
            Return.singleton model
                |> Return.command (Navigation.newUrl <| "#remote/" ++ name ++ "/" ++ version ++ "/" ++ path)

        LinkToHome ->
            Return.return model <| Navigation.newUrl "#"

        DragStart xy ->
            Return.singleton { model | drag = Just (Drag xy xy) }

        DragAt xy ->
            { model
                | navWidth =
                    model.navWidth
                        + (model.drag
                            |> Maybe.map (\{ current } -> xy.x - current.x)
                            |> Maybe.withDefault 0
                          )
                , drag = Maybe.map (\drag -> Drag drag.start xy) model.drag
            }
                |> Return.singleton
                |> Return.effect_
                    (\{ navWidth } ->
                        saveNavWidth navWidth
                    )

        DragEnd xy ->
            Return.singleton { model | drag = Nothing }

        DomFocus id ->
            Return.return model (focus id)

        DomBlur id ->
            Return.return model <| Task.attempt (\_ -> NoOp) (Dom.blur id)

        ListScrollTo index ->
            ( model, listScrollTo <| "item-" ++ toString index )

        SetSearchFocused focused ->
            ( { model | searchFocused = focused }, Cmd.none )

        LinkToModule modulePath ->
            Return.return model <|
                case model.page of
                    DocOverview docId ->
                        Navigation.newUrl <| "#local/" ++ docId ++ "/" ++ modulePath

                    DocModule docId path ->
                        Navigation.newUrl <| "#local/" ++ docId ++ "/" ++ modulePath

                    DisabledDoc doc path ->
                        Navigation.newUrl <| "#remote/" ++ doc.packageName ++ "/" ++ doc.packageVersion ++ "/" ++ modulePath

                    _ ->
                        Cmd.none

        DisabledDocNavExpand expand package ->
            { model
                | allPackages =
                    List.map
                        (\p ->
                            if p.name == package.name then
                                { p | versionExpanded = expand }
                            else
                                p
                        )
                        model.allPackages
                , selectedIndex =
                    model.navList
                        |> findIndex ((==) (DisabledDocNav package))
                        |> Maybe.withDefault model.selectedIndex
            }
                |> Return.singleton
                |> Return.map updateNavList
                |> Return.effect_
                    (\{ selectedIndex } ->
                        listScrollTo <| "item-" ++ toString (selectedIndex + List.length package.versions)
                    )

        OpenRemoteLink url ->
            Return.return model (openLink url)


focus : String -> Cmd Msg
focus id =
    Task.attempt (\_ -> NoOp) (Dom.focus id)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.batch
                [ keypress <| Keys.keyMap model ]

        Just _ ->
            Sub.batch
                [ Mouse.moves DragAt
                , Mouse.ups DragEnd
                ]


port scrollToElement : String -> Cmd msg


port saveLocal : { doc : Doc, searchIndex : List ( String, String ) } -> Cmd msg


port removeLocal : { doc : Doc, searchIndex : List ( String, String ) } -> Cmd msg


port saveNavWidth : Int -> Cmd msg


port keypress : (String -> msg) -> Sub msg


port listScrollTo : String -> Cmd msg


port openLink : String -> Cmd msg
