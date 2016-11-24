# elm-http-builder

[![Build Status](https://travis-ci.org/prikhi/elm-http-builder.svg?branch=master)](https://travis-ci.org/prikhi/elm-http-builder)

Chainable functions for building HTTP requests and composable functions for handling responses.

**Need help? Join the #http channel in the [Elm Slack](https://elmlang.herokuapp.com)!**

This is an Elm 0.18 fork of lukewestby's elm-http-builder package that provides
an API for specifying Responses as well as Requests.


## Example

In this example, we expect a successful response to be JSON array of strings,
like:

```json
["hello", "world", "this", "is", "the", "best", "json", "ever"]
```

and an error response might have a body which just includes text, such as the
following for a 404 error:

```json
Not Found.
```

We'll use `HttpBuilder.jsonReader` and a `Json.Decode.Decoder` to parse the
successful response body and `HttpBuilder.stringReader` to accept a string
body on error without trying to parse JSON.

```elm
import Task exposing (Task)
import Time
import HttpBuilder exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode


itemsDecoder : Decode.Decoder (List String)
itemsDecoder =
  Decode.list Decode.string


itemEncoder : String -> Encode.Value
itemEncoder item =
  Encode.object
    [ ("item", Encode.string item) ]


addItem : String -> Task (HttpBuilder.Error String) (HttpBuilder.Response (List String))
addItem item =
  HttpBuilder.post "http://example.com/api/items"
    |> withJsonBody (itemEncoder item)
    |> withHeader "Content-Type" "application/json"
    |> withTimeout (10 * Time.second)
    |> withCredentials
    |> send (jsonReader itemsDecoder) stringReader
```
