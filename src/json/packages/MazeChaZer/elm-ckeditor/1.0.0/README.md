# elm-ckeditor

Use the CKEditor within your Elm app via web components.

It is required to set up
[webcomponent-ckeditor](https://gitlab.com/MazeChaZer/webcomponent-ckeditor)
and [necessary polyfills](https://www.webcomponents.org/polyfills) first.

Demo: https://mazechazer.gitlab.io/elm-ckeditor/

```elm
view : Model -> Html Msg
view model =
    ckeditor
        [ config model.config
        , content model.content
        , onCKEditorChange CKEditorChanged
        ]
        []
```
