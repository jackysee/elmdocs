[![Build Status](https://travis-ci.org/Gizra/elm-compat-018.svg?branch=master)](https://travis-ci.org/Gizra/elm-compat-018)

# elm-compat-018

This is a module for Elm 0.18 which allows you to use some of the things in Elm
0.17's [`elm-lang/core`](http://package.elm-lang.org/packages/elm-lang/core/4.0.0)
which were changed in Elm 0.18.

It should be said that the best way to experience all the goodness of Elm 0.18
is to actually modify your projects to use Elm 0.18's version of these changes.
And [elm-format](https://github.com/avh4/elm-format) has some nice features to
help you do that easily.

However, there are cases in which you might want to keep using some "retro"
features of Elm 0.17. Perhaps they are handy for your particular scenario, or
perhaps you are maintaining some code that you need to compile in multiple
versions of Elm.

So, this library may be of some assistance in those cases.

## API

For the detailed API, see the
[Elm package site](http://package.elm-lang.org/packages/Gizra/elm-compat-018/latest),
or the links to the right, if you're already there.

As you will see, the modules from `elm-lang/core` with changes that can be
ported to Elm 0.18 are included here with the Elm version as a suffix. So,
suppose you want to use the old `customDecoder` from the Elm 0.17 version of
`Json.Decode`, you can do something like this:

    import Json.Decode017 exposing (customDecoder)

If you're maintaining some code for both Elm 0.17 and 0.18, then the necessary
change is then limited to the `import` statement -- in the Elm 0.17 version,
you'd just change the import to:

    import Json.Decode exposing (customDecoder)

One thing which doesn't quite work (but might be nice) is:

    import Json.Decode017 as Json
    import Json.Decode as Json

The problem is that each has an `andThen`, so `Json.andThen` becomes ambiguous.

However, if you're maintaining code for both Elm 0.17 and 0.18, you could do
something like the following.

    -- In the Elm 0.18 file, use the following imports:
    import Json.Decode as Json
    import Json.Decode017 as Json17

    -- In the Elm 0.17 file, use the following imports:
    import Json.Decode as Json
    import Json.Decode as Json17

Then, in the body of the either file, when you need something that is specific
to Elm 0.17, you can say something like `Json17.andThen`. In both cases, you'll
get the function you want.

If you also want to use some things that are specific to Elm 0.18, you can
install [`Gizra/elm-compat-017`](http://package.elm-lang.org/packages/Gizra/elm-compat-017/latest)
in the Elm 0.17 project, and then do something like this:

    -- In the Elm 0.18 file, use the following imports:
    import Json.Decode as Json
    import Json.Decode as Json18
    import Json.Decode017 as Json17

    -- In the Elm 0.17 file, use the following imports:
    import Json.Decode as Json
    import Json.Decode as Json17
    import Json.Decode018 as Json18

If you do that, then you can say `Json17.andThen` or `Json18.andThen` in either
file, and in both cases you'll get the function you expect.

Just to reiterate, none of this is standard operating procedure -- normally,
you will be best served by just updating everything to the latest version of
Elm.  So, this is just for the very few cases where it makes sense to work in
multiple versions of Elm at the same time.

## Installation

Try `elm-package install Gizra/elm-compat-018`

## Development

Try something like:

    git clone https://github.com/Gizra/elm-compat-018
    cd elm-compat-018
    npm install
    npm test
