# elm-clarity-ui

[![Build Status](https://travis-ci.org/mc706/elm-clarity-ui.svg?branch=master)](https://travis-ci.org/mc706/elm-clarity-ui)
[![Stories in Ready](https://badge.waffle.io/mc706/elm-clarity-ui.png?label=ready&title=Ready)](https://waffle.io/mc706/elm-clarity-ui?utm_source=badge)

Elm Package for Wrapping VM-Ware's Clarity UI. 

## Getting Started

* Add `mc706/elm-clarity-ui` to your `elm-package.json`

```elm
module Main exposing (..)

import ClarityUI.CDN as CDN
import ClarityUI.Layout as Layout
import ClarityUI.Header as Header exposing (HeaderColor(..))
import ClarityUI.Subnav as Subnav
import ClarityUI.Sidenav as Sidenav exposing (NavItem(Link, Group))


view : Model -> Html Msg
view model =
    div []
        [ CDN.styles
        , CDN.icons
        , ClarityUI.Layout.layout
            { alerts = [ viewAlerts model ]
            , header = viewHeader model
            , subnav = [ viewSubnav model ]
            , sidenav = [ viewSidenav model ]
            , main = [ mainContent model ]
            }
        , CDN.iconsJS
        ]


viewAlerts : Model -> Html Msg
viewAlerts model =
    div [] []


viewHeader : Model -> Html Msg
viewHeader model =
    Header.header
        HC6
        { branding = { icon = "vm-bug", title = "Elm Clarity UI" }
        , nav = []
        , search = []
        , actions = []
        }


viewSubnav : Model -> Html Msg
viewSubnav model =
    ClarityUI.Subnav.subnav
        [ { link = "#", text = "Example1" }
        , { link = "#", text = "Example2" }
        , { link = "#", text = "Example3" }
        , { link = "#", text = "Example4" }
        ]


mainContent : Model -> Html Msg
mainContent model =
    div [] []


viewSidenav : Model -> Html Msg
viewSidenav model =
    ClarityUI.Sidenav.sidenav
        [ Link { link = "#", text = "Nav Element 1" }
        , Link { link = "#", text = "Nav Element 2" }
        , Group
            { id = "tab1"
            , label = "Collapsible Nav Element"
            , collapsible = True
            , navList =
                [ { link = "#", text = "Link 1" }
                , { link = "#", text = "Link 2" }
                ]
            }
        , Group
            { id = "tab2"
            , label = "Default Nav Element"
            , collapsible = False
            , navList =
                [ { link = "#", text = "Link 1" }
                , { link = "#", text = "Link 2" }
                , { link = "#", text = "Link 3" }
                , { link = "#", text = "Link 4" }
                , { link = "#", text = "Link 5" }
                , { link = "#", text = "Link 6" }
                ]
            }
        ]

```

## Inspiration
Heavily influenced by [elm-bootstrap](http://elm-bootstrap.info/) and [elm-mdl](https://debois.github.io/elm-mdl/).



