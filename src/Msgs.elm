module Msgs exposing (..)

import Models exposing (..)
import Http


type Msg
    = NoOp
    | LoadAllPackages Bool (Result Http.Error (List Package))
    | AddDoc ( String, String )
    | RemoveDoc Doc
    | PinDoc (List ( String, String )) (Result Http.Error Doc)
    | GetCurrentDocFromPackage Package
    | GetCurrentDocFromId String String
    | SetCurrentDoc String Doc
    | Search String
    | ToggleShowDisabled
    | SearchPackage String
    | SetShowConfirmDeleteDoc (Maybe DocId)
    | SetSelectedIndex Int
    | MsgBatch (List Msg)
    | DocNavExpand Bool DocId
