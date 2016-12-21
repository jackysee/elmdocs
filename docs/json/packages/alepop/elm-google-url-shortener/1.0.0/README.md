# elm-google-url-shortener
An Elm interface to the [Google Url Shortener API](https://developers.google.com/url-shortener/)

Basic usage:

```elm
import Shortener exposing (..)
import Http

apiKey : ApiKey
apiKey =
    "google_api_key"

type Msg
    = ShortenerResult (Result Http.Error Shortener.Response)

shortUrl : Url -> Cmd Msg
shortUrl url =
  RequestData apiKey url
    |> Shortener.send ShortenerResult
```