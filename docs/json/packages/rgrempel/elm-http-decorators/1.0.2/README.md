# elm-http-decorators

This package provides some useful functions which work with
[elm-http](https://github.com/evancz/elm-http)

## Functions

```elm
addCacheBuster : (Settings -> Request -> Task RawError Response) -> (Settings -> Request -> Task RawError Response)
```

Decorates `Http.send` so that a 'cache busting' parameter will always be
added to the URL -- e.g. '?cacheBuster=219384729384', where the number is
derived from the current time.  The purpose of doing this would be to help
defeat any caching that might otherwise take place at some point between the
client and server.

```elm
promoteError : Task RawError Response -> Task Error Response
```

Decorates the result of `Http.send` so that the error type is `Http.Error`
rather than `Http.RawError`. This may be useful in cases where you are not
using `Http.fromJson`, and your API prefers to deal with `Http.Error` rather
than `Http.RawError`.

```elm
interpretStatus : Task RawError Response -> Task Error Response
```

Decorates the result of `Http.send` so that responses with a status code
which is outside of the 2XX range are processed as `BadResponse` errors (to be
further handled via `Task.onError` or `Task.mapError` etc.), rather than as
successful responses (to be further handled by `Task.andThen` or `Task.map`
etc.).  This may be useful in cases where you are not using `Http.fromJson` and
you do not need to distinguish amongst different types of successful status
code.

## Combining the functions

You can apply the decorators to individual uses of `Http.send` -- for example:

```elm
addCacheBuster Http.send Http.defaultSettings
    { verb = "GET"
    , headers = []
    , url = Http.url "/api/account" []
    , body = Http.empty
    }
```

Alternatively, you can compose a decorated function and use it repeatedly, e.g.

```elm
specialSend : Settings -> Request -> Task RawError Response
specialSend = addCacheBuster Http.send
```

The definition of something like `specialSend` is left for client code, so that
you can mix and match whichever decorators you need. You could conceivably also
want to partially apply `Http.defaultSettings` (or your own defaultSettings).
Thus, one combination which can be useful is as follows:

```elm
verySpecialSend : Request -> Task Error Response
verySpecialSend = interpretStatus << addCacheBuster Http.send Http.defaultSettings
```

You could then call `verySpecialSend` like this:

```elm
verySpecialSend
    { verb = "GET"
    , headers = []
    , url = Http.url "/api/account" []
    , body = Http.empty
    }
```

... and, of course, you could still provide an `andThen`, `map`, `mapError`, `onError` etc.
to do any further work that might be needed with the `Http.Error` or `Http.Result`.

Alternatively, if the `Settings` need to vary at each call-site, you can do something
like this:

```elm
lessSpecialSend : Settings -> Request -> Task Error Response
lessSpecialSend settings = interpretStatus << addCacheBuster Http.send settings
```

Note that some of this is redundant if you are using `Http.fromJson` anyway, since
`Http.fromJson` already does the equivalent of `promoteError` and `interpretStatus`.
