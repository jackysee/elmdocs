module Models exposing (..)


type alias Model =
    { allPackages : List Package
    , pinnedDocs : List Doc
    , currentDoc : Maybe ( String, Doc )
    , searchIndex : List ( String, String )
    , searchResult : List ( String, String )
    , searchText : String
    , showDisabled : Bool
    , searchPackageText : String
    , showConfirmDeleteDoc : Maybe DocId
    , selectedIndex : Int
    }


type alias StoreModel =
    { docs : List Doc
    , searchIndex : List ( String, String )
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
