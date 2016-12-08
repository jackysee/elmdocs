# Updated List

Elm package for working with \"lists\" of all kinds (ul, ol, table, etc.)

# Example

```elm
module Main exposing (..)

import UpdatedList as UL
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type UpdateRow
    = SetName String


type Msg
    = ChangeList (UL.ListItemAction UpdateRow)


viewItem : String -> Html (UL.Id -> UL.ListItemAction UpdateRow)
viewItem item =
    tr []
        [ td [] [ text item ]
        , td []
            [ button [ onClick UL.AddListItem ] [ text "Add" ]
            , button [ onClick UL.RemoveListItem ] [ text "Remove" ]
            , button [ onClick UL.EditListItem ] [ text "Edit" ]
            ]
        ]


disableItem : String -> Html (UL.Id -> UL.ListItemAction UpdateRow)
disableItem item =
    tr []
        [ td [] [ text item ]
        , td [] []
        ]


editItem : String -> Html (UL.Id -> UL.ListItemAction UpdateRow)
editItem item =
    tr []
        [ td [] [ input [ value item, onInput <| UL.UpdateListItem << SetName ] [] ]
        , td []
            [ button [ onClick UL.SaveListItem ] [ text "Save" ]
            , button [ onClick UL.CancelEditListItem ] [ text "Cancel" ]
            ]
        ]


view : UL.Model String -> Html Msg
view model =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "Name" ], th [] [ text "Actions" ] ]
            ]
        , tbody []
            (List.map (Html.map ChangeList) <| UL.createItemsView model viewItem editItem disableItem)
        ]


update : Msg -> UL.Model String -> ( UL.Model String, Cmd Msg )
update msg model =
    case msg of
        ChangeList action ->
            ( UL.updateList action model updateRow, Cmd.none )


updateRow : UpdateRow -> String -> String
updateRow msg _ =
    case msg of
        SetName name ->
            name


names : List String
names =
    [ "John", "Ann", "Lisa" ]


init : ( UL.Model String, Cmd Msg )
init =
    ( UL.init
        { itemList = names
        , emptyElement = ""
        }
    , Cmd.none
    )


main : Program Never (UL.Model String) Msg
main =
    program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : a -> Sub Msg
subscriptions msg =
    Sub.none

```
