# Styled Html for Elm

[elm-styled-html]() is a drop-in replacement for [elm-lang/html](http://package.elm-lang.org/packages/elm-lang/html/latest)
inspired by [css-modules](https://github.com/css-modules/css-modules) that automatically scopes CSS classes.

* Allows composing and nesting of scoped classes and any other selector.
* Replaces inline styling with *anonymous* classes, to reduce clutter and enable using pseudo-selectors.
* Makes unique both named and anonymous classes by adding a hash string of their content to their names.

```elm
redBackgroundClass =
    makeClass "redBackground"
        [ "background-color: #e00" ]
        []


view model =
    div
        [ class redBackgroundClass ]
        [ span
            [ onClick 5
            , style
                [ "background-color: blue"
                , "font-size: 30px"
                ]
                [ selector ":hover"
                    [ "background-color: cyan" ]
                    []
                ]
            ]
            [ text (toString model) ]
        ]
```
([See it running](https://xarvh.github.io/elm-styled-html/))


## First, a warning

This package is *experimental*. Expect bugs, awkward & changing interface and poor performance.


## How do I use it?

1) Install the package: `elm-package install --yes xarvh/elm-styled-html`

2) Replace all `Html` imports with the respective `StyledHtml`:

  Before:
  ```elm
  import Html exposing (..)
  import Html.Attributes as Attributes exposing (class)
  ```

  After:
  ```elm
  import StyledHtml as Html exposing (..)
  import StyledHtml.Attributes as Attributes exposing (class)
  ```

3) The syntax for `Attributes.style` has changed, it now takes two lists as arguments:

  ```elm

   div
      [ Attributes.style
          [ "background-color: blue" ]
          [ StyledHtml.Css.selector ":hover"
            [ "text-transform: uppercase" ]
            []
          ]
      ]
      [ text "I have blue background and become uppercase on hover!" ]
  ```

  The first list is for the normal style attributes.

  The second list is for composed selectors.

  See the docs for the [StyledHtml.Css]() module for more details!


4) The syntax for `Attributes.class` has changed, you have to use `StyledHtml.Css.makeClass`
  to create the class first:

  ```elm
  classButton =
      StyledHtml.Css.makeClass "button"
          [ "padding: 10px"
          , "border: 1px solid blue"
          ]
          [ StyledHtml.Css.selector ":hover"
              [ "background-color: purple" ]
              []
          ]
  ```
  Again, the first list is for style attributes, the second list is for composed selectors.

  ```elm
  div
      [ Attributes.class classButton ]
      [ text "I look like a button" ]
  ```

  Check [StyledHtml.Css.andClass]() to see how to compose classes together!

5) That's all you need to start playing around.
If you need more control, check the docs and the examples.


## Can I use it with elm-css?
Yes, you can use this transform:
```elm
elmCssMixinsToStyledHtmlSnippets : List Css.Mixin -> List String
elmCssMixinsToStyledHtmlSnippets elmCssMixins =
    elmCssMixins
        |> Css.asPairs
        |> List.map (\( name, value ) -> name ++ ": " ++ value)
```


## Can I use it to write entirely dynamic classes?
Yes, but it might affect the rendering performance. See below.


## Ok, what's the catch?
There might be a few:

1) The package is experimental. I'll learn as I use it. I really don't know what to expect.

2) The generated `<style>` tag will change dynamically with the page. This might force the browser to redraw a lot more than necessary.

3) The calculations done under the hood might affect performance. Inlined anonymous classes are rebuilt and hashed at every rendering cycle.

4) `Html.Lazy` and `Html.Keyed` are not yet implemented.

