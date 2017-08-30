# 📏 Elm Modular Scale
A library for generating numerical values derived from musical intervals. A tool that will help you create proportionally related values to be used as font sizes, element widths, line height, ect.

Based on the idea found at <a target="_blank" href="http://www.modularscale.com/">modularscale.com</a>

## Usage

    config : Config
    config =
        { base = [ 1 ]
        , interval = PerfectFifth
        }

    get : Config -> Int -> Float 
    get config 5

    --> 7.59375

    ms : Int -> String
    ms x =
        toString (get config x) ++ "em"

    h1 [ style [ ( "font-size", ms 4 ) ] ][ text "Foo" ]

Check the <a href="http://package.elm-lang.org/packages/rl-king/elm-modular-scale/latest/ModularScale">docs</a> for more information.

Also check out <a href="https://vimeo.com/17079380" target="blank">this</a> great talk by Tim Brown, introducing this concept.