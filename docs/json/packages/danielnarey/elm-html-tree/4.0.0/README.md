## An alternative syntax for generating HTML in Elm

`HtmlTree` is an alternative syntax for generating HTML, built on top of the
standard `Html` and `VirtualDom` packages. This syntax enables a
["pipeline"](https://en.wikipedia.org/wiki/Pipeline_%28software%29)
approach to HTML specification, and its implementation allows for downstream
modification of view components — something that is not possible when working
with the standard API. Once constructed, view components may be passed to modify
functions as data, encouraging a design pattern for updating a program's view
that may result in more intuitive and readable code.

__Motivation__

The main disadvantage of the standard API is that once a chunk of HTML has been
constructed, e.g.,

    welcomeMessage =
      div [] [ p [] [ text "Hello, World!" ] ]

there is no direct way of looking inside that chunk to get information about its
elements or their attributes. For example, it would not be possible to pass
`welcomeMessage` to a function that would add a style attribute to the `p`
element or change the text to "Hello, Universe!" and return the result. With the
standard libraries, to make either of these modifications, we would need to
re-write the nested `Html` function calls with modified arguments or insert
conditionals that would change the arguments passed to the function in response
to data. This limitation takes away some of the appeal of using a functional
style of programming for front-end web development.

The `HtmlTree` library solves this problem by creating a set of types that
provide a representation of the HTML DOM in Elm, allowing access to each node's
internal data. The union type `HtmlTree` defines a recursive tree where each
node contains an element record and some nodes also contain a list of child
`HtmlTree` nodes. This data structure allows an `HtmlTree` to be passed to a
function that will access its internal data, build a modified `HtmlTree`, and
return the result, just as one can do with any other Elm type.

With `HtmlTree`, the code to produce `welcomeMessage` may be written like this:

    welcomeMessage =
      container "div" [ textWrapper "p" "Hello, world!" ]

Or, using the `|>` operator, like this:

    welcomeMessage =
      "Hello, world!"
        |> textWrapper "p"
        |> List.singleton
        |> container "div"

Suppose that we would like to be able to change the style of the text after this
chunk of HTML has been encoded and assigned to a variable name. We can do this
by adding a CSS class to the `p` element as follows:

    import HtmlTree.Modify as Modify
    ...

    welcomeMessage
      |> Modify.matchingTag "p"
        ( addClass "large-bold-text" )

Note, however, that if there were multiple `p` elements in the tree, this
function call would add the class "large-bold-text" to all of them. An
alternative is to define the `id` attribute of the element we wish to modify and
then use the `matchingId` function:

    welcomeMessage =
      "Hello, world!"
        |> textWrapper "p"
        |> withId "messageText"
        |> List.singleton
        |> container "div"

    welcomeMessage
      |> Modify.matchingId "messageText"
        ( addClass "large-bold-text" )

The text of the message can be modified in a similar way:

    welcomeMessage
      |> Modify.matchingId "messageText"
        ( withText "Hello, Universe!" )

And so on.

__Examples__

Full working examples can be found
[here](https://github.com/danielnarey/elm-html-tree/tree/master/examples). These are adaptations of the examples at [elm-lang.org](http://elm-lang.org/examples).

__Dependencies__
- [elm-lang/core/5.1.1](http://package.elm-lang.org/packages/elm-lang/core/5.1.1)
- [elm-lang/html/2.0.0](http://package.elm-lang.org/packages/elm-lang/html/2.0.0)
- [evancz/elm-markdown/3.0.1](http://package.elm-lang.org/packages/evancz/elm-markdown/3.0.1)
- [danielnarey/elm-css-basics/3.0.1](http://package.elm-lang.org/packages/danielnarey/elm-css-basics/3.0.1)
