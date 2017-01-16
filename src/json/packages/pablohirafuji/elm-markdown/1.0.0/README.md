# Elm Markdown

Pure elm markdown. This package is for markdown parsing and rendering. [Demo](https://pablohirafuji.github.io/elm-markdown/examples/Demo.html).

## Basic Usage


    type Msg
        = MsgOfmyApp1
        | MsgOfmyApp2
        | MsgOfmyApp3
        | Markdown


    markdownView : Html Msg
    markdownView =
        Html.map (always Markdown)
            <| section []
            <| Markdown.toHtml "# Heading with *emphasis*"


## Supported syntax


### Heading

To create a heading, add one to six `#` symbols before
your heading text. The number of `#` you use will determine
the size of the heading.

    # Heading 1
    ## Heading 2
    ###### Heading 6



### Quoting

Lines starting with a `>` will be a block quote.


    > Block quote



### Code

Use a sequence of single backticks (`` ` ``) to output code.
The text within the backticks will not be formatted.
To format code or text into its own distinct block, use
at least three backticks or four spaces or tab.


    Example of `inline code`
    
        Example of block code

    ```optionalLang
    Example of block code
    ```

If the language in the fenced code block is defined,
it will be added a `class="language-optionalLang"` to
the output code element.


### Link

You can create an inline link by wrapping link text in
brackets `[ ]`, and then wrapping the URL in parentheses `( )`.

    Do you know the Elm [slack channel](https://elmlang.slack.com/)?

Or create a reference link:

    [slackLink]: https://elmlang.slack.com/

    Do you know the Elm [slack channel][slackLink]?

Or even:

    [slack channel]: https://elmlang.slack.com/

    Do you know the Elm [slack channel]?

All examples output the same html.

Autolinks and emails are supported with `< >`:

    Autolink: <http://www.google.com.br>
    Email link: <google@google.com.br>


### Lists

You can make a list by preceding one or more lines of
text with `-` or `*`.


    - Unordered list
      * Nested unordered list
    5. Ordered list starting at 5
        1) Nested ordered list


### Paragraphs and line breaks

You can create a new paragraph by leaving a blank line
between lines of text.


    Here's a paragraph with soft break line
    at the end.

    Here's a paragraph with hard break line\
    at the end.


By default, soft line break (`\n`) will be rendered as it is,
unless it's preceded by two spaces or `\`, witch will output
hard break line (`<br>`).

You can customize to always render soft line breaks as hard
line breaks setting `softAsHardLineBreak = True` in the options.


### Thematic Break Line

You can create a thematic break line with a sequence of three
or more matching `-`, `_`, or `*` characters.


    ***
    ---
    ___



### Emphasis

You can create emphasis using the `*` or `_` characters.
Double emphasis is strong emphasis.


    *Emphasis*, **strong emphasis**, ***both***

    _Emphasis_, __strong emphasis__, ___both___



### Image

You can insert image using the following syntax:


    ![alt text](src-url "title")


For more information, see [CommonMark Spec](http://spec.commonmark.org/0.27/).



## Options

The following options are available:


```elm
type alias Options =
    { softAsHardLineBreak : Bool
    , rawHtml : HtmlOption
    }


type HtmlOption
    = ParseUnsafe
    | Sanitize SanitizeOptions
    | DontParse


type alias SanitizeOptions =
    { allowedHtmlElements : List String
    , allowedHtmlAttributes : List String
    }
```

- `softAsHardLineBreak`: Default `False`. If set to `True`, will render `\n` as `<br>`.
- `rawHtml`: Default `Sanitize defaultSanitizeOptions`.
You can choose to not parse any html tags (`DontParse`) or allow any html tag without any sanitization (`ParseUnsafe`).


Default allowed elements and attributes:

```elm
defaultSanitizeOptions : SanitizeOptions
defaultSanitizeOptions =
    { allowedHtmlElements =
        [ "address", "article", "aside", "b", "blockquote"
        , "body","br", "caption", "center", "cite", "code", "col"
        , "colgroup", "dd", "details", "div", "dl", "dt", "figcaption"
        , "figure", "footer", "h1", "h2", "h3", "h4", "h5", "h6", "hr"
        , "i", "legend", "li", "link", "main", "menu", "menuitem"
        , "nav", "ol", "optgroup", "option", "p", "pre", "section"
        , "strike", "summary", "small", "table", "tbody", "td"
        , "tfoot", "th", "thead", "title", "tr", "ul" ]
    , allowedHtmlAttributes =
        [ "name", "class" ]
    }
```

Please note that is provided basic sanitization.
If you are accepting user submmited content, use a specific library.


## Customization

You can customize how each markdown element is rendered.
The following examples demonstrate how to do it.

- Example of rendering all links with `target=_blank` if does not start with a specific string. [Demo](https://pablohirafuji.github.io/elm-markdown/examples/CustomLinkTag.html) / [Code](https://github.com/pablohirafuji/elm-markdown/blob/master/examples/CustomLinkTag.elm)
- Example of rendering all images using `figure` and `figcaption`.
[Demo](https://pablohirafuji.github.io/elm-markdown/examples/CustomImageTag.html) / [Code](https://github.com/pablohirafuji/elm-markdown/blob/master/examples/CustomImageTag.elm)


## TODO

- Improve docs;
- Improve tab parser;
- Get feedback if encoded characters replacement is needed;
- Get feedback about missing wanted features;
- Get feedback about the API;
