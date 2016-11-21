module Models exposing (..)


type alias Model =
    { allPackages : List Package
    , pinnedDocs : List Doc
    , currentDoc : Maybe ( String, Doc )
    , searchIndex : List ( String, String )
    , searchResult : List ( String, String )
    , searchText : String
    , showDisabled : Bool
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
