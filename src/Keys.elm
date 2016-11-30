module Keys exposing (keyMap)

import Msgs exposing (..)
import Models exposing (..)
import Utils exposing (findFirst)


keyMap : Model -> String -> Msg
keyMap model key =
    if key == "down" then
        let
            len =
                if model.searchText == "" then
                    List.length model.navList
                else
                    List.length model.searchResult

            index =
                min (model.selectedIndex + 1) (len - 1)
        in
            MsgBatch <| [ SetSelectedIndex index ] ++ focusMsg model index
    else if key == "up" then
        let
            index =
                max 0 (model.selectedIndex - 1)
        in
            MsgBatch <| [ SetSelectedIndex index ] ++ focusMsg model index
    else if key == "enter" then
        if model.searchText == "" then
            selectedItemMsg
                model.selectedIndex
                model.navList
                (\navItem ->
                    case navItem of
                        DocNav d ->
                            LinkToPinnedDoc "" d.id

                        ModuleNav m docId ->
                            LinkToPinnedDoc m.name docId

                        DisabledDocNav p ->
                            case List.head p.versions of
                                Just version ->
                                    LinkToDisabledDoc p.name version ""

                                Nothing ->
                                    NoOp

                        DisabledDocOtherVersionNav p version ->
                            if List.member version p.availableVersions then
                                LinkToDisabledDoc p.name version ""
                            else
                                OpenRemoteLink <| "http://package.elm-lang.org/packages/" ++ p.name ++ "/" ++ version

                        _ ->
                            NoOp
                )
        else
            selectedItemMsg model.selectedIndex
                model.searchResult
                (\( path, docId ) -> LinkToPinnedDoc path docId)
    else if key == "esc" then
        MsgBatch
            [ Search ""
            , DomFocus "search-input"
            , LinkToHome
            ]
    else if key == "right" && model.searchText == "" then
        selectedItemMsg
            model.selectedIndex
            model.navList
            (\navItem ->
                case navItem of
                    DocNav d ->
                        DocNavExpand True d.id

                    DisabledHandleNav ->
                        SetShowDisabled True

                    DisabledDocNav p ->
                        if List.length p.versions > 0 then
                            DisabledDocNavExpand True p
                        else
                            NoOp

                    _ ->
                        NoOp
            )
    else if key == "left" && model.searchText == "" then
        selectedItemMsg
            model.selectedIndex
            model.navList
            (\navItem ->
                case navItem of
                    DocNav d ->
                        DocNavExpand False d.id

                    ModuleNav m docId ->
                        DocNavExpand False docId

                    DisabledHandleNav ->
                        SetShowDisabled False

                    DisabledDocNav p ->
                        if List.length p.versions > 0 then
                            if p.versionExpanded then
                                DisabledDocNavExpand False p
                            else
                                SetShowDisabled False
                        else
                            NoOp

                    DisabledDocOtherVersionNav p version ->
                        DisabledDocNavExpand False p

                    _ ->
                        NoOp
            )
    else if not model.searchFocused && key == "." then
        DomFocus "search-input"
    else
        NoOp


focusMsg : Model -> Int -> List Msg
focusMsg model index =
    [ ListScrollTo index ]
        ++ if model.searchText /= "" then
            []
           else if model.selectedIndex == 0 && index == 0 then
            [ DomFocus "search-input" ]
           else
            model.navList
                |> Utils.atIndex index
                |> Maybe.map
                    (\navItem ->
                        case navItem of
                            DisabledInputNav ->
                                [ DomFocus "package-search-input" ]

                            _ ->
                                [ DomFocus <| "item-" ++ toString index
                                , DomBlur "package-search-input"
                                ]
                    )
                |> Maybe.withDefault []


selectedItemMsg : Int -> List a -> (a -> Msg) -> Msg
selectedItemMsg index list mapper =
    findFirst
        (\( i, _ ) -> i == index)
        (List.indexedMap (,) list)
        |> Maybe.map (\( i, d ) -> mapper d)
        |> Maybe.withDefault NoOp
