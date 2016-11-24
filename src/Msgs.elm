module Msgs exposing (..)

import Models exposing (..)
import Http
import Navigation exposing (Location)
import Mouse exposing (Position)


type Msg
    = NoOp
    | LoadAllPackages Bool Location (Result Http.Error (List Package))
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
    | DragStart Position
    | DragAt Position
    | DragEnd Position
