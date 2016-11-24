module Msgs exposing (..)

import Models exposing (..)
import Http


type Msg
    = NoOp
    | LoadAllPackages Bool (Result Http.Error (List Package))
    | AddDoc ( String, String )
    | RemoveDoc Doc
    | PinDoc (List ( String, String )) (Result Http.Error Doc)
    | GetCurrentDocFromPackage String String String
    | SetDisabledDoc Doc
    | SetDisabledDocModule String
    | SetCurrentDocFromId String DocId
    | Search String
    | ToggleShowDisabled
    | SearchPackage String
    | SetShowConfirmDeleteDoc (Maybe DocId)
    | SetSelectedIndex Int
    | MsgBatch (List Msg)
    | DocNavExpand Bool DocId
    | LinkToPinnedDoc String DocId
    | LinkToDisabledDoc String String String
