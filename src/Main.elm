module Main exposing (..)

import App exposing (..)
import Models exposing (Model, StoreModel, Page)
import Msgs exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (Parser, parseHash, oneOf, map, s, string, top, (</>))


-- import String.Extra

import String


main : Program (Maybe StoreModel) Model Msg
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
            (s "packages" </> string </> string </> string </> string)
        , map
            (\user package version ->
                SetCurrentDocFromId "" (String.join "/" [ user, package, version ])
            )
            (s "packages" </> string </> string </> string)
        , map
            (\user package version path ->
                GetCurrentDocFromPackage (user ++ "/" ++ package) version path
            )
            (s "disabled" </> string </> string </> string </> string)
        , map
            (\user package version ->
                GetCurrentDocFromPackage (user ++ "/" ++ package) version ""
            )
            (s "disabled" </> string </> string </> string)
        , map (SetCurrentDocFromId "" "") top
        ]


locFor : Location -> Msg
locFor location =
    parseHash route location
        |> Maybe.withDefault NoOp
