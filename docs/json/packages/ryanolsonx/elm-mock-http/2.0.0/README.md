# Elm Mock Http

A client-side server to simulate server-side communications that are made
through `elm-lang/Http`

Have you ever been in one of these situations?

- You want to prototype your front-end without propping up a back-end server.
- You're in charge of the front-end and someone else is in charge of the back-end
but you want to test out your Elm application, even while the back-end is still
in flux?
- You want to test out different responses to guide how you can shape your back-end,
without all of the back-end work?

If so, then this project is for you.

It allows you to use an api that just about mirrors the `elm-lang/http` server-side
calls.

## What Does This Do?

`elm-mock-http` allows you to configure endpoints which will define what data
should return when you make certain calls with a url and HTTP verb.

For example, you could set up an endpoint that says 'when I receive a GET request
for url http://example.com/getBooks' it should return '["Book 1", "Book 2"]'. When
you use `MockHttp` while developing, you could then make a `MockHttp.get` request and
then send it using `MockHttp.send`. You will receive your response back decoded into
whatever type you defined.

The key point is that `MockHttp` is a temporary measure that allows you to:
1. Get your json decoder fully functional
2. Flesh out your views
3. Test out what things would look like with different response times
4. Use a temporary endpoint until a server-side endpoint is available

Ultimately, at some point, you'll want to change your `MockHttp` mentions to `Http`
and receive your responses from a server.

## Getting Started

There are only a few things you'll need to do in order to get started:
1. Install this package.
2. Import `MockHttp` in your Elm file.
3. Change your `Http` calls to `MockHttp`
4. Configure your mock endpoints and their responses.
5. You're good to go!

### Step 1: Install Package

Install this package using `elm package install ryanolsonx/elm-mock-http`

### Step 2: Add Import
Add `MockHttp` to your imports
```elm
import MockHttp exposing (Endpoint(..))
```

### Step 3: Change your `Http` calls to `MockHttp`

Imagine if you had this:
```elm
import Http
import Json.Decode exposing (list, string)

type Msg
    = GetBook
    | ReceiveBooks (List String)

update msg model =
  case msg of
    GetBook ->
      Http.send ReceiveBooks (Http.get "https://example.com/books" (list string))
```

You could mock out the `https://example.com/books` api replacing
the `Http` calls with `MockHttp` like below (ignore the `config` part for now):

```elm
import Http
import Json.Decode exposing (list, string)
import MockHttp

type Msg
    = GetBook
    | ReceiveBooks (List String)

update msg model =
  case msg of
    GetBook ->
      MockHttp.send config ReceiveBooks (MockHttp.get "https://example.com/books" (list string))

config : MockHttp.Config
...
```

**note**: you must replace where you're creating the request as well as where you send the http request. For example, you couldn't just change `Http.get` to `MockHttp.get` and then send that through `Http.send`.

### Step 4: Configure Endpoints

In order for `MockHttp` to know what mock data to return for different calls, you need to create a `Config` and then pass it in with everything `MockHttp.send`. You can create one as seen below:

```elm
config : MockHttp.Config
config =
    MockHttp.config
        [ Get
            { url = "https://example.com/books"
            , response = """
                [ "The Lord of the Rings"
                , "Harry Potter"
                ]
              """
            }
        ]
```

This example will make it so that when you run the following code you'll get those two books as a response.

```elm
import Http
import Json.Decode exposing (list, string)

getBooks : Http.Request (List String)
getBooks =
  MockHttp.get "https://example.com/books" (list string)

type Msg = GetBook | ReceiveBooks (List String)

update msg model =
  case msg of
    GetBook ->
      (model, MockHttp.send config ReceiveBooks getBooks)
    ReceiveBooks books ->
      -- Do something great with those books!
```

## Errors

You can expect errors similar to running a normal `Http` request.

You can only encounter two of the `Http.Error` options:
- `Http.BadPayload`: If something goes wrong decoding the response configured
in your endpoint.
- `Http.BadUrl`: If the url you try to get or post to does not match any of
the configured endpoints.

## Contributing
I'm happy to recieve any feedback and ideas for additional features. Any input
and pull requests are welcome and encouraged! I really want to make this a useful
tool during development that will make our lives easier. If you'd like to help or
have any ideas, get in touch with me at @ryanolsonx on Twitter or @ryanolsonx on
the Elm Slack.
