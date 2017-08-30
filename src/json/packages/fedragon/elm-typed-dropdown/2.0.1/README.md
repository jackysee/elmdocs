# elm-typed-dropdown

This library provides a dropdown that can deal with items of any arbitrary type `t`. Items are not part of this component's internal model, meaning that there is a single source of truth: your own `Model`.

It sets the selected item by value, rather than by index, which can be useful when the set of items is dynamic. User selection is communicated by returning an `Event` that contains the whole selected item. 

## Features

- Items can be of any type `t`
- Items are not part of internal component model
- Item selected by value, rather than by index
- User selection communicated via `Event`
- Style can be customized by providing `Settings`

## Usage

```elm
import Dropdown exposing (Dropdown, Event(ItemSelected))

-- type of items in this dropdown
type alias Country =
    { code : String
    , name : String
    }


type alias Model =
    { dropdown : Dropdown
    , items : List Country -- items that will be shown in dropdown
    , selectedItem : Maybe Country -- selected item, if any
    , ...
    }


type Msg
    = CountrySelected (Dropdown.Msg Country)
    | ...


init =
    Model
        Dropdown.init
        [ Country "ALB" "Albania"
        , Country "ITA" "Italy"
        , Country "NLD" "Netherlands"
        ]
        Nothing
        ...


update msg model =
    case msg of
        CountrySelected dropdownMsg ->
            let
                ( updatedDropdown, event ) =
                    Dropdown.update dropdownMsg model.dropdown
            in
                case event of
                    ItemSelected country ->
                        { model
                            | dropdown = updatedDropdown
                            , selectedItem = Just country
                        }

                    _ ->
                        { model | dropdown = updatedDropdown }
        ...


view model =
    ...
        , div []
            [ Html.map CountrySelected <|
                Dropdown.view
                    model.items
                    model.selectedItem
                    .name
                    model.dropdown
            ]
        ]
```

See `examples` folder for complete usage examples. You can find the minimal set of styles that should be applied to the dropdown in provided `dropdown.css`.

### Customize style

Use `Dropdown.initWithSettings` rather than `init` if you want to use your own styles rather than the default ones.

## Credits

This library's design was deeply influenced by Evan Czaplicki's [About API Design](https://github.com/evancz/elm-sortable-table#about-api-design) and [elm-datepicker](https://github.com/elm-community/elm-datepicker).
