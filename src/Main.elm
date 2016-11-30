module Main exposing (..)

import App exposing (..)
import Models exposing (Model, StoreModel, Page)
import Msgs exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (Parser, parseHash, oneOf, map, s, string, top, (</>))
import String
import Json.Decode
import Views exposing (view)


-- import String.Extra


main : Program (Maybe Json.Decode.Value) Model Msg
main =
    Navigation.programWithFlags
        locFor
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


route : Parser (Msg -> a) a
route =
    oneOf
        [ map
            (\user package version path ->
                SetCurrentDocFromId path (String.join "/" [ user, package, version ])
            )
            (s "local" </> string </> string </> string </> string)
        , map
            (\user package version ->
                SetCurrentDocFromId "" (String.join "/" [ user, package, version ])
            )
            (s "local" </> string </> string </> string)
        , map
            (\user package version path ->
                GetCurrentDocFromPackage (user ++ "/" ++ package) version path
            )
            (s "remote" </> string </> string </> string </> string)
        , map
            (\user package version ->
                GetCurrentDocFromPackage (user ++ "/" ++ package) version ""
            )
            (s "remote" </> string </> string </> string)
        , map (SetCurrentDocFromId "" "") top
        ]


locFor : Location -> Msg
locFor location =
    parseHash route location
        |> Maybe.withDefault NoOp
