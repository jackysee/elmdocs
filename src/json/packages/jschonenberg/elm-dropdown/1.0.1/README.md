# elm-dropdown
`elm-dropdown` offers a flexible component which can serve as a foundation for custom dropdowns, select-inputs, popovers, and more.

#### Features:
* Pure, state gets passed in from the parent.
* Use any HTML-element as toggle or drawer.
* Choose for toggle on on click, hover, or focus.
* Supports keyboard navigation (`tab`, `esc`).
* No backdrop-element, direct interaction with other elements is possible.
* Unassuming about visual style, bring your own CSS.

#### Example

Basic example of use:

    init : Model
    init =
        { myDropdown = False }


    type alias Model =
        { myDropdown : Dropdown.State }


    type Msg
        = ToggleDropdown Bool


    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            ToggleDropdown newState ->
                ( { model | myDropdown = newState }, Cmd.none )


    view : Model -> Html Msg
    view model =
        div []
            [ dropdown
                model.myDropdown
                myDropdownConfig
                (toggle button [] [ text "Toggle" ])
                (drawer div
                    []
                    [ button [] [ text "Option 1" ]
                    , button [] [ text "Option 2" ]
                    , button [] [ text "Option 3" ]
                    ]
                )
            ]


    myDropdownConfig : Dropdown.Config Msg
    myDropdownConfig =
        Dropdown.Config
            "myDropdown"
            OnClick
            (class "visible")
            ToggleDropdown 
