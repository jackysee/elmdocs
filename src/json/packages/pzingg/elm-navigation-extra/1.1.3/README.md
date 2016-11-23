# elm-navigation-extra

This is a package for routing single-page-apps in Elm, building on the
[`elm-lang/navigation`](http://package.elm-lang.org/packages/elm-lang/navigation/latest)
package. It is a variation of rgrempel's excellent
[`rgrempel/elm-route-url`](http://package.elm-lang.org/packages/rgrempel/elm-route-url/latest)
package. I just wanted to see what a different flavor of setting up
a `Navigation.program` with his routing protocols would look like.

I apologize for the massive amount of documentation and code copying from
his package to this one, but perhaps it will clarify the differences.

## Rationale

Essentially, this package helps you to keep the URL displayed in the browser's
location bar in sync with the state of your app. As your app changes state, the
displayed URL changes to match. If the user changes the URL (through a
bookmark, the back/forward button, or typing in the location bar), then your
app changes state to match.

So, there are two things going on here:

* Mapping changes in our app's state to changes in the browser's location.
* Mapping changes in the browser's location to changes in our app's state.

Now, you can already arrange for these things to happen using
[`elm-lang/navigation`](http://package.elm-lang.org/packages/elm-lang/navigation/latest).
Furthermore, there are already a wealth of complementary packages,
such as:

* [evancz/url-parser](http://package.elm-lang.org/packages/evancz/url-parser/latest)
* [Bogdanp/elm-combine](http://package.elm-lang.org/packages/Bogdanp/elm-combine/latest)
* [Bogdanp/elm-route](http://package.elm-lang.org/packages/Bogdanp/elm-route/latest)
* [etaque/elm-route-parser](http://package.elm-lang.org/packages/etaque/elm-route-parser/latest)
* [poyang/elm-router](http://package.elm-lang.org/packages/poying/elm-router/latest)
* [sporto/erl](http://package.elm-lang.org/packages/sporto/erl/latest)
* [sporto/hop](http://package.elm-lang.org/packages/sporto/hop/latest)

So, what does this package (or elm-route-url, which it steals from) do
differently than the others?


### Mapping changes in the app state to a possible location change

If you were using [`elm-lang/navigation`](http://package.elm-lang.org/packages/elm-lang/navigation/latest)
directly, then you would make changes to the URL with ordinary commands.
So, as you write your `update` function, you would possibly return a command,
using [`modifyUrl`](http://package.elm-lang.org/packages/elm-lang/navigation/1.0.0/Navigation#modifyUrl)
or [`newUrl`](http://package.elm-lang.org/packages/elm-lang/navigation/1.0.0/Navigation#newUrl).

In this package, the generation of these commands are encapsulated by a function
that you must implement with this type signature:

```elm
delta2url : Model -> Model -> Maybe UrlChange
```

In your program's `update` function, whenever your model's state changes and
you want to generate a new URL, you call `delta2url` with the previous model
and the new model. Your `delta2url` implementation can analyze those two
model states and possibly produce a change to the URL, encapsulated in the
`UrlChange` type, or `delta2url` can return `Nothing` if the URL should
stay the same.  (The reason you get both the old and new model is because
sometimes it helps you decide whether to create a new history entry,
or just replace the old one).

You take the `Maybe UrlChange` result of `delta2url` and send it to
this package's `Navigation.Router.urlChanged` function. This function
does a comparison to make sure that the URL is actually different than
the URL cached in the router's model and then if it really is a change,
issues the `Navgation.newUrl` or `Navigation.modifyUrl` command.

This means:

* You just calculate the appropriate URL, given the state of your app.
  automatically avoids creating a new history entry if the
  URL hasn't changed.

* The router can automatically avoid an infinite loop if the change in the
  app's state was already the *result* of a URL change.

Of course, you can solve those issues with your own code. However, if you
use this package, you don't have to.


### Mapping location changes to messages our app can respond to

To handle location changes in the official [navigation](http://package.elm-lang.org/packages/elm-lang/navigation/latest)
package in Elm 0.18 directly, you are asked to implement an argument
to `Navigation.program` that converts a `Location` to a message
type (that you name) whenever the URL changes. For purposes of discussion,
let's assume you create this message type:

```elm
type Msg =
    LocationChanged Navigation.Location
```

and you set up your main module something like this:

```elm
main : Program Never Model Msg
main =
  Navigation.program LocationChanged
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }
```

To use the loop-avoidance logic provided by this package, you have
to keep the router updated when your program's `init` and `update` functions
receive a new location.

To maintain the router's state, first put a `Navigation.Router.Model` member in
your program's model:

```elm
type alias Model =
  { ... members to maintain your program's state ...
  , router : Navigation.Router.Model
  }
```


Then in your program's `init` function, call this package's
`Navigation.Router.init` function to set up the router's state when the
location of the initial frame is received:

```elm
init : Navigation.Location -> ( Model, Cmd Msg )
init location =
  ( { ..., router = Navigation.Router.init }, Cmd.none )
```


In your program's `update` function, when you receive a `LocationChanged`
message, you must let the router know (and let it check to see whether it
is an "inside" or "outside" change) by calling the
`Navigation.Router.locationChanged` function.

Then, you implement a function with this type signature:

```elm
location2messages : Location -> List Msg
```


`location2messages` lets your program respond to a new URL to change
the state of your program by issuing new messages that can update the
state. It's up to your implementation to parse the Location and generate
zero or more messages that can change the state.

In the `LocationChanged` branch of your `update` function,
you pass this `location2messages` function to a function that the
`Navigation.Router` module provides, named `processLocation`.

`processLocation` calls back to your `location2messages` in two cases:

1. With the initial frame's location

2. When a location change is coming from the "outside", through a link,
or the user typing into the browser's location bar, etc. (not from a state
change that generated a new location via `delta2url`).


## Example

There is a simple counter application included that shows the coding
that has to be added to a standard `Navigation.program` to make it all
work. In the example `delta2url` changed the `hash` of the URL to include
the value of the counter, like `#!/2`, and `location2messages`
parses the hash into a list and generates a `SetCount Int` message (if
the first member of the list is an integer) to update the counter.

The example shows how to build and parse the location hash two ways:

* with the `UrlParser` module from the `evancz/url-parser` package.

* or with the included `Navigation.Builder` module (which is identical
    to the `Builder` module from the `rgrempel/elm-route-url` package).


## API

For the detailed API, see the documentation for `Navigation.Router`
and `Navigation.Builder` (there are links to the right,
if you're looking at the Elm package site).

`Navigation.Builder` (which is an Elm 0.18 upgrade of rgrempel's
`RouteUrl.Builder`) is a module that makes it easy to construct
and parse URL changes.  However, you don't need to use it -- many other
approaches would be possible, and there are links to helpful packages above.
