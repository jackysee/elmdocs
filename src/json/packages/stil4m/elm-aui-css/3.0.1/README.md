# elm-aui-css

An UI component library for the Elm supporting integration with the CSS of the [Atlassian AUI Framework](https://docs.atlassian.com/aui).

## Install

```
elm package install stil4m/elm-aui-css
```

## Notes

Currently there is one component that requires ports (Single Select) to focus and blur input. You should setup this for example as follows:

```
port module MyModule (..)

port blur : String -> Cmd msg
port focus : String -> Cmd msg

initialModel =
    { selectModel =
        initialModel { blur = blur, focus = focus } ...
    , ...
    }
```

See `Demo/Select.elm` for more details. `index.html` contains information how to set up the ports.

## Supported Components

* Avatars
* Badges
* Buttons
* Dropdown
* Expander
* Icons
* Labels
* Lozenge
* Messages
* Page
* Progress Indicator
* Progress Tracker
* Single Select
* Tabs
* Toggle
* Toolbar

If you request another component, please create an issue for it or create a pull request (that would be great).

## Using Components

See the demo source code for each component how to use it.
