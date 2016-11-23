An experimental alternative to Graphics.Element and elm-html

The concept being explored by this rendering library is to have the core element
type be a function of `{x,y,w,h} -> rendering` instead of simply being a rendering.
This leads to some interesting properties with respect to creating dynamic layouts,
and thus far appears to give a nice API for quickly creating and modifying layouts.
It also provides a mechanism for creating reusable layout logic.

## Usage

elm-layout is still under development.  If you would like to use it, follow these steps:

1. Fork this project
2. Use `git subtree` to add elm-layout to your project

    ```
    git subtree add -P lib/elm-layout git@github.com:avh4-experimental/elm-layout.git master --squash
    ```

3. Add `./lib/elm-layout/src/` to the list of `source-directories` in your project's `elm-package.json`.

## Example

```elm
import Layout
import Window

view =
    Layout.top 48
        (Layout.placeholder "header")
        ( [1..25]
            |> List.map (\n -> "Item " ++ (toString n))
            |> List.map Layout.placeholder
            |> Layout.list 32
            |> Layout.inset 8
        )

main = Layout.toFullWindow (Signal.constant view)
```

![](demo1.png)
