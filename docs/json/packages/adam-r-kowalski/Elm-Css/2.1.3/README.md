# Elm-Css - DEPRECATED
---

### This will not work with the latest version of Elm!

You have two choices

1. visit [elm-style](https://github.com/adam-r-kowalski/elm-style) which is my new take on how styles should be done.
2. visit [elm-css-legacy](https://github.com/adam-r-kowalski/elm-css-legacy) which is this exact repository but renamed to be all lowercase.

### This repository will no longer have any updates!

---

This library allows you to use composable functions to construct your Css.

## Quick Start
---
1. Clone the repository

    git clone https://github.com/adam-r-kowalski/Elm-Css.git

2. Navigate to the proper directory

    cd Elm-Css/

3. Run the reactor

    elm-reactor

4. Open [the example](http://localhost:8000/Example.elm) and read through the tutorial.

Inspired by [React: CSS in JS](https://speakerdeck.com/vjeux/react-css-in-js) by vjeux

## Features
---

* Composable styles
* Type checking
* Automatic vendor prefixing
* Easily use device width instead of pixel width

## Overview
---

Elm-Css aims to provide you with the building blocks you need to create styles within Elm.
A key takeaway is that each style is composable and as a result is very easy to extend with further functionality.
The code you do write is also much simpler to test and refactor, as well as guaranteed type safety and cross browser support.

## Example
---
### Centering Content
    centered : Styles -> Styles
    centered styles =
      styles
        |> display Display.Flex
        |> Flex.justifyContent Flex.JCCenter
        |> Flex.alignItems Flex.AICenter

    view : Html
    view =
        div [ style <| centered [] ] [ setViewport, text "Hello World" ]

As you can see the code is very declarative but is not quite a one to one mapping of CSS.
For this reason I strongly encourage you to read the documentation and learn how to use everything Elm-Css has to offer.
I also recommend that each of your style functions takes in a list of styles and returns a list of styles.
This allows you to have very composable styles that can build off one another to create more useful functionality.

## Further Reading
---
Read the source code or the generated documentation!
It provides you with all you need to know to get started as well as an overview of all the completed functions.

## Extending Elm-CSS
---
Elm-Css is meant to be extended and customized so that it fits your needs.
Say for example that you would like to have margin bottom function that relies on percents instead of pixels.

    import Css exposing (Styles)


    pc : number -> String
    pc num =
      (toString num) ++ "% "


    bottom : number -> Styles -> Styles
    bottom b styles =
      Css.style "margin-bottom" (pc b) styles
    
Well that was easy, in fact while this library provides you with a lot of helper functions to make your life easier.
It is entirely possible to follow this pattern in your project without using Elm-Css.

    type alias Styles = List (String, String)


    style : String -> String -> Styles -> Styles
    style name value styles =
      List.append styles [ (name, value) ]


    pc : number -> String
    pc num =
      (toString num) ++ "% "


    bottom : number -> Styles -> Styles
    bottom b styles =
      Css.style "margin-bottom" (pc b) styles
    
This could obviously be extended to become as complicated and elaborate as you would like.
One strategy that seems to be popular is to accept a string instead of a number for the functions like so.

    bottom : String -> Styles -> Styles
    bottom b styles =
      Css.style "margin-bottom" b styles

Then you could use functions such as pc which generatates the appropriate strings based off of an input which can be type checked.

In summary I don't think it is worth rewriting all of the things that this library provides for you,
but I definitely think you should extend it and make it work the way that is best for you.
If you would like to see how to deal with vendor prefixes I would look at the source for the flex 
