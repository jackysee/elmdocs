# President.elm

A simple way to turn your Elm code into a presentation.

## Why.

Presentation editors have lots of great features to play around with.
But they are usually limited in how they let you present things interactively.
Enter Elm. Elm makes it fun to program interactive web pages.

## How.

A President slide is simply a `Signal Element`. Make your presentation by putting the
slides into a list and calling `President.present`. This is a working presentation:

```elm
import Signal exposing (Signal,constant)
import Text exposing (..)
import Time
import Graphics.Element exposing (Element, centered)
import Graphics.Collage exposing (..)
import President

animation t = 
  collage 800 800 [
    fromString "Animations!" |> typeface ["Comic Sans MS"] 
    |> height 120 |> centered |> toForm |> rotate (sin (t/250) * 0.2)
    ]

slides: List (Signal Element)
slides = [
  constant <| centered <| height 120 
    <| fromString "Use left/right arrow keys to navigate",
  Signal.map animation (Time.every (60*Time.millisecond)),
  constant <| centered <| height 120 
    <| fromString "Use up/down arrow keys to go to beginning/end"
  ]

main = President.present slides
```

## Plans

This thing is just about as simple as it gets. There should probably be some more options for slide navigation, positioning, etc. Perhaps transitions if you want to get fancy.

## Problems

Elm still has plenty of issues, some of which break President slides
in particular. Presentations can break under following conditions:

* scaled `Element`s followed by collages
* `fittedImage` elements followed by regular `image`
* other weird things.

