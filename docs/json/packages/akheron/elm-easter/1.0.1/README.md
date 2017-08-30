# elm-easter

elm-easter is a pure Elm library for computing the date of Easter for
any given year, using Western, Orthodox or Julian algorithms.


## Example

    -- Easter in year 2017, according to Western (most common) algorithm
    easter Western 2017  -- 2017-04-16

    -- Easter in year 1416, according to the Orthodox algorithm
    easter Orthodox 1416  -- 1416-04-29

See
[the Elm package](http://package.elm-lang.org/packages/akheron/elm-easter/latest) for
full documentation.


## Development

Run the test suite:

    elm-test
