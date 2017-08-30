[![Build Status](https://travis-ci.org/Gizra/elm-attribute-builder.svg?branch=master)](https://travis-ci.org/Gizra/elm-attribute-builder)

# elm-attribute-builder

Elm's [Html] module constructs HTML nodes by asking you to provide,
among other things, a list of HTML attributes. So, you might typically
see something like:

[Html]: http://package.elm-lang.org/packages/elm-lang/html/latest

    div
        [ class "ui button primary"
        , onClick DoLogin
        ]
        [ text "Login" ]

Sometimes it is convenient to build up the list of attributes through
a series of computations. One can, of course, simply use functions
that return lists of attributes and combine them together ... perhaps
something like this:

    div
        ( List.concat
            [ computation1 model
            , computation2 user
            , [ class "another-class"
              , style [("position", "absolute")]
              ]
            ]
        )
        [ text "Login" ]

And, in Elm 0.18, Elm does some things you might expect with this:

  - If you provide multiple "class" attributes, they get combined appropriately.
    (This wasn't the case in Elm 0.17, which was actually the original motivation
    for this package).

  - If you provide multiple "style" attributes, they are all used.

However, sometimes you might want to build attributes up using types that
give you some more fine-tuned control. That is the purpose of this package.
It allows you to something like this:

    import Html.AttributeBuilder as AB

    AB.attributeBuilder
        |> AB.union (computation1 model)
        |> AB.union (computation2 user)
        |> AB.addClass "another-class"
        |> AB.removeClass "unwanted-class"
        |> AB.addStyle "position" "absolute"
        |> AB.toAttributes

What you get at the end of such a pipeline is a `List Html.Attribute`,
constructed in a way that you might enjoy.

## API

For the detailed API, see the
[Elm package site](http://package.elm-lang.org/packages/Gizra/elm-attribute-builder/latest),
or the links to the right, if you're already there.

## Installation

Try `elm-package install Gizra/elm-attribute-builder`

## Development

Try something like:

    git clone https://github.com/Gizra/elm-attribute-builder
    cd elm-attribute-builder
    npm install
    npm test
