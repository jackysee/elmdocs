module Models exposing (..)

import Utils exposing (findFirst)
import Mouse exposing (Position)


type alias Model =
    { allPackages : List Package
    , newPackages : List String
    , pinnedDocs : List Doc
    , page : Page
    , searchIndex : List ( String, String )
    , searchResult : List ( String, String )
    , searchText : String
    , showDisabled : Bool
    , showNewOnly : Bool
    , searchPackageText : String
    , showConfirmDeleteDoc : Maybe DocId
    , selectedIndex : Int
    , navWidth : Int
    , drag : Maybe Drag
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


toDocNavItemList : List Doc -> List DocNavItem
toDocNavItemList list =
    list
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
