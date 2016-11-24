# Elm sticky header
A sticky header for Elm applications. This is the classical header you can find
in mobile-friendly websites, where the header slides up when scrolling down and
remains attached to the top when scrolling up.

For a live example check [this url](https://pietro909.github.io/elm-sticky-header/public/).

It allows to define:
 * _logo_, some HTML to be places on the left of the title
 * _brand_, the main title to be shown on the menu
 * _links_, a list of links to be displayed on the menu

It takes care of tracking the current selected link, applying the `active` class.

## Why
Using Elm, I found a lack of UI components ready to use. Namely, I developed this
one while working at [MaltaJS registration page](https://github.com/roedit/maltajs-elm).

## Usage

Install the package:

$ elm package install pietro909/elm-sticky-header

Then include the module in your application (in this case, `Mail.elm`):

```elm
    -- import the module
    import StickyHeader

    -- include in your Model
    type alias Model =
        { headerModel: StickyHeader.Model }

    -- use the init function to initialize the Model
    initialModel =
        let
            headerBrand =
                StickyHeader.buildItem "StickyHeader demo" [ ]
        in
            { headerModel = StickyHeader.initialModel (Just headerBrand) [] }\

    -- define a union type for the message
    type Msg
        = StickyHeaderMsg StickyHeader.Msg
        | -- all your messages

    -- handle the message in your update function
    update msg model =
        case msg of
            -- your messages here
            StickyHeaderMsg subMsg->
                let
                    ( updatedHeaderModel, headerCmd ) =
                        StickyHeader.update subMsg model.headerModel
                in
                    ( { model | headerModel = updatedHeaderModel }
                    , Cmd.map StickyHeaderMsg headerCmd
                    )
```

Now that you are handling the message and the update, you need to hand over the
model to the module's view function:

```elm
    -- view function
    view model =
        article []
            [ -- your code here
            , App.map StickyHeaderMsg (StickyHeader.view model.headerModel)
            ]
```

Last step is to activate the port which deals with the actual window's scroll
event. Let's create it in the `Ports.elm` file:

```
port scroll : (Scroll.Move -> msg) -> Sub msg  
```

Now import it in your `Main.elm` module and forward it to the subscriptions function:

```elm
    subscriptions : Model -> Sub Msg
    subscriptions model =
        List.map (Platform.Sub.map StickyHeaderMsg) (StickyHeader.subscriptions Ports.scroll model.headerModel)
        |> Sub.batch
```

And then add the Javscript code which will feed the port with event's data:

```javascript
  <script>
    // just an example of how to bootstrap the app
    var mountNode = document.getElementById('main');
    var myApp = Elm.Main.embed(mountNode);

    // port binding is here!
    var scroll = window.pageYOffset || document.body.scrollTop;
    window.onscroll = function() {
      var newScroll = window.pageYOffset || document.body.scrollTop;
      myApp.ports.scroll.send([scroll, newScroll]);
      scroll = newScroll;
    };
  </script>
```

## Styling

The component renders an Html structure like this one:

```htm
<header> 
    <h1><a>Brand</a></h1>
    <nav>
        <a>first link</a>
        <!-- ...links here -->
    </nav>
</header>
```

You can pass a list of CSS classes to be applied to the links with `StickyHeader.buildItem`. The classes will be assigned to the `<a>` element.

When an link is selected, the default `active` class is applied, thus allowing you to style it properly.

## Further readings

For more informations on how the module's inclusion works, please refer to the
official documentation here: [Composing components](https://www.elm-tutorial.org/en/02-elm-arch/06-composing.html)

## Running the example

$ git clone https://github.com/pietro909/elm-sticky-header.git
$ cd elm-sticky-header
$ make

Open `elm-sticky-header/public/index.hml` with your a modern browser.

## Thanks

The elm [Slack Elm community](https://elmlang.slack.com) and namely `beginner` and
`animations` channels.

[Adam Brykajlo](https://github.com/abrykajlo) who created [elm-scroll](https://github.com/abrykajlo/elm-scroll),
 and is used in this component.
