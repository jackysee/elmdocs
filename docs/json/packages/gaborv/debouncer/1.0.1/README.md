# Debouncer

A simple package which lets you aggregate a number of incoming messages and trigger some processing only after a delay.<br/>
For basic usage please look at the following sample.


```elm
import Debouncer
import Time

type Msg
  = EmailFieldUpdated String
  | PhoneUpdated String
  | DebouncerSelfMsg (Debouncer.SelfMsg Msg)
  | ValidateEmail String
  | ValidatePhone String

type alias Model =
  { email : String
  , phone : String
  , debouncer : Debouncer.DebouncerState
  }

init : Model
init =
  { email = ""
  , phone = ""
  , debouncer = Debouncer.create (2*Time.second)
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        EmailFieldUpdated email ->
            let
                (debouncer, debouncerCmd) = model.debouncer |> Debouncer.bounce { id = "email", msgToSend = (ValidateEmail email) }
            in
                { model 
                | debouncer = debouncer
                , email = email
                } !
                    [debouncerCmd |> Cmd.map DebouncerSelfMsg]

        PhoneUpdated phone ->
            let
                (debouncer, debouncerCmd) = model.debouncer |> Debouncer.bounce { id = "phone", msgToSend = (ValidatePhone phone) }
            in
                { model 
                | debouncer = debouncer
                , phone = phone
                } !
                    [debouncerCmd |> Cmd.map DebouncerSelfMsg]

        DebouncerSelfMsg debouncerMsg ->
            let
                (debouncer, cmd) = model.debouncer |> Debouncer.process debouncerMsg
            in
                { model | debouncer = debouncer} ! [ cmd ]

        ValidateEmail email ->
            Debug.crash "Not implemented"

        ValidatePhone phone ->
            Debug.crash "Not implemented"
```
