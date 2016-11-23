# elm-bootforms

This package tries to provide a very simple and powerful interface to HTML(5) forms powered by [bootstrap](http://getbootstrap.com/). It uses [evancz/elm-html](http://package.elm-lang.org/packages/evancz/elm-html/latest/) as HTML rendering backend.

## Docs

See [agrafix/elm-bootforms](http://package.elm-lang.org/packages/agrafix/elm-bootforms/latest/) on the central elm package repo.

## Example

```elm
import Date
import Html.Form.Input as I

type alias Model =
    { date: I.FormValue String Date.Date
    , name: I.FormValue String String
    }

type Action
    = Nop
    | SetDate (I.FormValueAction String Date.Date)
    | SetName (I.FormValueAction String String)

init : (Model, Effects Action)
init =
    (
        { date = { userInput = "", value = Err "no date", focused = False }
        , name = I.stringFormVal ""
        }
    , Effects.none
    )

noFx : Model -> (Model, Effects Action)
noFx m = (m, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update a m =
    case a of
        Nop -> noFx m
        SetDate f -> ({ m | date = I.apply f m.date }, I.mappedEffect SetDate f)
        SetName f -> ({ m | name = I.apply f m.name }, I.mappedEffect SetName f)

view : Signal.Address Action -> Model -> H.Html
view addr =
    H.lazy <| \m ->
    H.div []
    [ H.h2 [] [ text "My super form" ]
    , I.dateInput
        { id = "some-date"
        , label = "Date"
        , helpBlock = Just "Example: 04.02.2015"
        , value = m.date
        , onValue = Signal.message addr << SetDate
        }
    , I.textInput
      { id = "some-name"
      , label = "The name"
      , helpBlock = Just "Example: 14:35"
      , value = m.name
      , onValue = Signal.message addr << SetDeparture
      }
    }
```

## Install

Install using [elm-package](https://github.com/elm-lang/elm-package).

# Roadmap

* Support generating complete forms with error handling
* ...
