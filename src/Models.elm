module Models exposing (..)

import Utils exposing (findFirst, joinMaybe, simpleMatch, sortPath, findIndex)
import Mouse exposing (Position)
import String.Extra
import Regex


type alias Model =
    { allPackages : List Package
    , newPackages : List String
    , pinnedDocs : List Doc
    , navList : List DocNavItem
    , page : Page
    , searchIndex : List ( String, String )
    , searchResult : List ( String, String )
    , searchText : String
    , searchFocused : Bool
    , showDisabled : Bool
    , showNewOnly : Bool
    , searchPackageText : String
    , showConfirmDeleteDoc : Maybe DocId
    , selectedIndex : Int
    , navWidth : Int
    , drag : Maybe Drag
    , addDocState : AddDocState
    }


type alias Drag =
    { start : Position
    , current : Position
    }


type Page
    = Home
    | DocOverview DocId
    | DocModule DocId String
    | DisabledDoc Doc String
    | NotFound
    | Loading


type DocNavItem
    = DocNav Doc
    | ModuleNav Module DocId
    | DisabledHandleNav
    | DisabledInputNav
    | DisabledDocNav Package
    | DisabledDocOtherVersionNav Package String


type AddDocState
    = AddDocLoading ( String, String )
    | AddDocIdle


type alias StoreModel =
    { docs : List Doc
    , searchIndex : List ( String, String )
    , navWidth : Int
    }


defaultStoreModel : StoreModel
defaultStoreModel =
    { docs = []
    , searchIndex = []
    , navWidth = 238
    }


type alias Package =
    { name : String
    , summary : String
    , versions : List String
    , availableVersions : List String
    , versionExpanded : Bool
    }


type alias DocId =
    String


type alias Doc =
    { id : DocId
    , packageName : String
    , packageVersion : String
    , modules : List Module
    , readme : String
    , navExpanded : Bool
    }


type alias Module =
    { name : String
    , comment : String
    , aliases : List Alias
    , types : List ModuleType
    , values : List Value
    , generatedWithElmVesion : String
    }


type Entry
    = AliasEntry Alias
    | ModuleTypeEntry ModuleType
    | ValueEntry Value


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


getDocById : Model -> DocId -> Maybe Doc
getDocById model docId =
    if String.isEmpty docId then
        Nothing
    else
        findFirst (\d -> d.id == docId) model.pinnedDocs


disabledPackages : Model -> List Package
disabledPackages model =
    let
        pinnedDocVersions =
            List.map
                (\d -> ( d.packageName, d.packageVersion ))
                model.pinnedDocs
    in
        model.allPackages
            |> List.filter
                (\p ->
                    (not
                        (p.versions
                            |> List.map (\v -> ( p.name, v ))
                            |> List.all (\d -> List.member d pinnedDocVersions)
                        )
                    )
                        && ((model.showNewOnly && List.member p.name model.newPackages) || not model.showNewOnly)
                        && if model.searchPackageText /= "" then
                            if Regex.contains (Regex.regex "^\\/*$") model.searchPackageText then
                                False
                            else
                                simpleMatch model.searchPackageText p.name
                           else
                            True
                )
            |> List.sortBy
                (\p ->
                    sortPath "/" model.searchPackageText p.name
                )


updateNavList : Model -> Model
updateNavList model =
    let
        pinnedDocVersions =
            List.map
                (\d -> ( d.packageName, d.packageVersion ))
                model.pinnedDocs
    in
        { model
            | navList =
                (model.pinnedDocs
                    |> List.map
                        (\d ->
                            [ DocNav d ]
                                ++ if d.navExpanded then
                                    d.modules
                                        |> List.sortBy .name
                                        |> List.map (\m -> ModuleNav m d.id)
                                   else
                                    []
                        )
                    |> List.concat
                )
                    ++ [ DisabledHandleNav ]
                    ++ if model.showDisabled then
                        [ DisabledInputNav ]
                            ++ (disabledPackages model
                                    |> List.sortBy
                                        (\package ->
                                            findIndex ((==) package.name) model.newPackages
                                                |> Maybe.withDefault (List.length model.newPackages)
                                        )
                                    |> List.map
                                        (\p ->
                                            [ DisabledDocNav p ]
                                                ++ if List.length p.versions > 1 && p.versionExpanded then
                                                    p.versions
                                                        |> List.filter
                                                            (\v ->
                                                                not <| List.member ( p.name, v ) pinnedDocVersions
                                                            )
                                                        |> List.map (DisabledDocOtherVersionNav p)
                                                   else
                                                    []
                                        )
                                    |> List.concat
                               )
                       else
                        []
        }


type alias Version =
    { major : Int
    , minor : Int
    , patch : Int
    }


versionDesc : String -> String -> Order
versionDesc v1_ v2_ =
    let
        v1 =
            toVersion v1_

        v2 =
            toVersion v2_

        flippedCompare =
            \a b ->
                case compare a b of
                    LT ->
                        GT

                    GT ->
                        LT

                    EQ ->
                        EQ
    in
        if v1.major /= v2.major then
            flippedCompare v1.major v2.major
        else if v1.minor /= v2.minor then
            flippedCompare v1.minor v2.minor
        else
            flippedCompare v1.patch v2.patch


toVersion : String -> Version
toVersion str =
    let
        arr =
            String.split "." str
                |> List.map String.toInt
                |> List.map (Result.withDefault 0)
    in
        case arr of
            major :: minor :: patch :: [] ->
                { major = major, minor = minor, patch = patch }

            _ ->
                { major = 0, minor = 0, patch = 0 }


getLatestVerByDocId : Model -> DocId -> Maybe String
getLatestVerByDocId model docId =
    model.allPackages
        |> findFirst (\p -> String.Extra.leftOfBack "/" docId == p.name)
        |> Maybe.map (\p -> List.head p.versions)
        |> joinMaybe


isPinned : Model -> String -> String -> Bool
isPinned model package version =
    model.pinnedDocs
        |> List.any (\d -> d.id == package ++ "/" ++ version)
