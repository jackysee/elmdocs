module Msgs exposing (..)

import Models exposing (..)
import Http


type Msg
    = NoOp
    | LoadAllPackages Bool (Result Http.Error (List Package))
    | PinDoc (List ( String, String )) (Result Http.Error Doc)
    | GetCurrentDocFromPackage Package
    | GetCurrentDocFromId String
    | SetCurrentDoc String Doc
    | Search String
    | ToggleShowDisabled
