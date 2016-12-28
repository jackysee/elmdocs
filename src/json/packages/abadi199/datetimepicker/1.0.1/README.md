# Date and Time Picker

### [Live Demo](https://abadi199.github.io/datetimepicker/)

This package follows the `evancz\sortable-table` package approach where it's not a nested elm architecture 'component'. It's just view functions where you feed the data and the message constructor to the function. It does use an opaque `State` to maintain its internal state.

The picker requires the initial value of the date (usually today) to set the initial position of the calendar. To feed this date to the picker's internal state, you can use 2 approach
- By passing a `Date` value to the `DateTimePicker.initialStateWithToday` function when initialing the picker's State.
- By calling the `DateTimePicker.initialCmd` as part of your `init` commands.

## Views
The date time picker package provides multiple view functions, depending on how you want to use the picker.
- `datePicker` is a simple date picker view, with no time picker, and comes with all default configuration.
- `dateTimePicker` is a simple date and time picker view, comes with all default configuration.
- `datePickerWithConfig` is a configurable date picker view.
- `dateTimePickerWithConfig` is a configurable date and time picker view.

## Config
You customize the date picker configuration by passing a `DateTimePicker.Config.Config` value to the picker's view function.
The DateTimePicker.Config module provides some default configurations for both date picker and date time picker.

## CSS
The CSS for this date time picker can be downloaded from [here](https://raw.githubusercontent.com/abadi199/datetimepicker/master/styles/styles.css), or if you're using rtfeldman/elm-css package, you can just include the `Stylesheet` from `DateTimePicker.Css` module.
Date and Time Picker written entirely in Elm. 

## Example
Here's a snippet of typical Elm application:
```elm
main = 
    Html.program 
        { init = init 
        , view = view
        , update = update
        , subscriptions = subscriptions 
        }

type Msg 
    = DateChange DateTimePicker.State (Maybe Date)

type alias Model = 
    { selectedDate : Maybe Date
    , datePickerState : DateTimePicker.State 
    }

init = 
    ( { selectedDate = Nothing, datePickerState.initialState }
    , DateTimePicker.initialCmd DateChange DateTimePicker.initialState
    )

view model = 
    DateTimePicker.dateTimePickerWithConfig 
        DateChange 
        [ class "my-datetimepicker" ] 
        model.datePickerState 
        model.selectedDate

update msg model =
    case msg of
        DateChange datePickerState selectedDate ->
            ( { model | selectedDate = selectedDate, datePickerState = datePickerState }, Cmd.none ) 

subscriptions =
    ...


```

For a complete sample code, please see the [demo](https://github.com/abadi199/datetimepicker/tree/master/demo) folder of the source code.


## Date Time Picker

The date and time picker can be used in two modes:
- Analog Time Picker
- Digital Time Picker

### Analog time picker

Preview:

![alt text](https://github.com/abadi199/datetimepicker/raw/master/images/datetimepicker-analog.gif "Date Time Picker with Analog Time Picker Preview")

Example:
```elm
view model =
    DateTimePicker.dateTimePickerWithConfig
        { defaultDateTimeConfig | timePickerType = DateTimePicker.Config.Analog }
        [ class "my-datetimepicker" ]
        model.state
        model.value
```

### Digital time picker

Preview:

![alt text](https://github.com/abadi199/datetimepicker/raw/master/images/datetimepicker-digital.gif "Date Time Picker with Digital Time Picker Preview")

Example:
```elm
view model =
    DateTimePicker.dateTimePickerWithConfig
        { defaultDateTimeConfig | timePickerType = DateTimePicker.Config.Digital }
        [ class "my-datetimepicker" ]
        model.state
        model.value
```


Date Picker
---
Just the date picker without the time.

Preview:

![alt text](https://github.com/abadi199/datetimepicker/raw/master/images/datepicker.gif "Date Picker Preview")

Example:
```elm
type Msg = DateChange DateTimePicker.State (Maybe Date)

type alias Model = { value : Maybe Date, state : DateTimePicker.State }

view model =
    DateTimePicker.datePicker
        DateChange
        [ class "my-datepicker" ]
        model.state
        model.value
```

## Contributing
Feedback, PR, and comments are welcome :)