# elm-google-geocoding

An Elm interface to the [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding/intro)

This provides a pipeline friendly, builder-like API. It also provides Elm types for many of Google's JSON structures.

In the end it produces a `Task`, so you'll need to create your own `msg` types to tag success and failure when `perform`-ing the task

Basic usage:

```elm
import Geocoding
import Http
import Task

apiKey : String
apiKey = "your_google_api_key"

type Msg
  = GeocodingSuccess Geocoding.Response
  | GeocodingFailure Http.Error

geocodeThis : String -> Cmd Msg
geocodeThis str =
  Geocoding.requestForAddress apiKey str
    |> Geocoding.send
    |> Task.perform GeocodingFailure GeocodingSuccess
```

Take a look at the [tests](tests/Tests.elm) for examples of building requests with other parameters
