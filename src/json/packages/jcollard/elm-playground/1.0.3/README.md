Playground
==========

Playground attempts to add a layer of abstraction between the programmer and
Signals. 

To install, run `elm-package install jcollard/elm-playground` in the root directory of your elm project.

Examples
========

* [Increment](#increment): Basic example showing a number increment
* [Ball](#ball): Basic example showing an interactive circle
* [Mario](#mario): Basic example showing the classic Elm Mario demo.

## Increment
A number appears centered on the screen and increments every 60 milliseconds. If the user presses the space bar, the counter resets.

[See It Running](http://jcollard.github.io/elm/Playground/Increment.html)

```haskell
-- Increases an Int ~60 times per second. When the space bar is pressed, the Int
-- resets
update realworld input state = 
  case input of
    Tap k -> if | Keys.equal k Keys.space -> 0
                | otherwise -> state
    otherwise -> state + 1

render state = [asText state |> toForm]

main = play { render = render, update = update, initialState = 0 }
```


## Ball
A circle is drawn to the screen. Use the arrow keys to move it around the screen. Press `1`, `2`, or `3`, to change the circles color.

[See It Running!](http://jcollard.github.io/elm/Playground/Demo.html)

###Source
```haskell
-- Define what you want the state of your program to be
type State = {x : Float, y : Float, c : Color}
initialState : State
initialState = {x = 0, y = 0, c = blue}

-- Define how the state of your program should be rendered
render : State -> [Form]
render state = 
    let shape = circle 50 |> filled state.c |> move (state.x, state.y) 
    in [shape]

-- Define how your program is updated
update : RealWorld -> Input -> State -> State
update rw input state = 
    case input of
      Tap k ->
          if | Keys.equal k Keys.one -> {state | c <- blue}
             | Keys.equal k Keys.two -> {state | c <- red}
             | Keys.equal k Keys.three -> {state | c <- green}
             | otherwise -> state
      Key k ->
          if | Keys.equal k Keys.arrowLeft -> {state | x <- state.x - 5}
             | Keys.equal k Keys.arrowRight -> {state | x <- state.x + 5}
             | Keys.equal k Keys.arrowDown ->  {state | y <- state.y - 5}
             | Keys.equal k Keys.arrowUp -> {state | y <- state.y + 5}
             | otherwise -> state
      otherwise -> state

playground : Playground State
playground = {render = render, update = update, initialState = initialState}

main : Signal Element
main = play playground
```

## Mario
Move Mario using the arrow keys!

[See It Running!](http://jcollard.github.io/elm/Playground/Mario.html)

### Source

```haskell
-- Define what you want the state of your program to be
type State = { mario : Mario, background : Background}
type Background = { w : Float, h : Float }
type Mario = { x : Float, y : Float, vx : Float, vy : Float, dir : String}

initialState : State
initialState = { mario = { x=0, y=0, vx=0, vy=0, dir="right" }, 
                 background = {w = 0, h = 0}}

-- Define how the state of your program should be rendered
render : State -> [Form]
render {mario, background} =
  let (w,h) = (background.w, background.h)
      verb = if | mario.y  >  0 -> "jump"
                | mario.vx /= 0 -> "walk"
                | otherwise     -> "stand"
      src  = "http://elm-lang.org/imgs/mario/" ++ verb ++ "/" ++ mario.dir ++ ".gif"
  in [ rect w h  |> filled (rgb 174 238 238)
      , rect w 50 |> filled (rgb 74 163 41)
                  |> move (0, 24 - h/2)
      , toForm (image 35 35 src) |> move (mario.x, mario.y + 62 - h/2)
      ]

gravity : Time -> Mario -> Mario
gravity t mario = if mario.y > 0 then { mario | vy <- mario.vy - t/4 } else mario

physics : Time -> Mario -> Mario
physics t mario = { mario | x <- mario.x + t*mario.vx, 
                          y <- max 0 (mario.y + t*mario.vy),
                          vx <- 0}
jump : Mario -> Mario
jump mario = if mario.y == 0 then { mario | vy <- 5 } else mario

-- Define how your program is updated
update : RealWorld -> Input -> State -> State
update realworld input {mario, background} = 
       let mario' =
           case input of
             Key k ->
                 if | Keys.equal k Keys.arrowLeft -> {mario | vx <- mario.vx - 2, dir <- "left"}
                    | Keys.equal k Keys.arrowRight -> {mario | vx <- mario.vx + 2, dir <- "right"}
                    | otherwise -> mario
             Tap k ->
                 if | Keys.equal k Keys.arrowUp -> jump mario
                    | otherwise -> mario
             Passive t -> gravity (t/20) (physics (t/20) mario)
             otherwise -> mario
       in {mario = mario', 
           background = { w = realworld.right - realworld.left,
                          h = realworld.top - realworld.bottom}}

main = play {render = render, update = update, initialState = initialState}
```
 
