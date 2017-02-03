# elm-serverless-cors

[![serverless](http://public.serverless.com/badges/v3.svg)](http://www.serverless.com)
[![Elm Package](https://img.shields.io/badge/elm-1.0.0-blue.svg)](http://package.elm-lang.org/packages/ktonon/elm-serverless-cors/latest)
[![CircleCI](https://img.shields.io/circleci/project/github/ktonon/elm-serverless-cors.svg)](https://circleci.com/gh/ktonon/elm-serverless-cors)

This is [CORS][] middleware for [elm-serverless][].

## Usage

```elm
import Serverless.Conn exposing (pipeline, plug)
import Serverless.Conn.Types exposing (Method(..))
import Serverless.Cors exposing (..)


myPipeline =
    pipeline
        -- Sets access-control-allow-origin
        -- the same as the origin request header
        -- or if that is not found then "*"
        |>
            plug (allowOrigin ReflectRequest)
        -- Sets access-control-allow-methods
        |>
            plug (allowMethods [ GET, OPTIONS ])
```

[CORS]:https://en.wikipedia.org/wiki/Cross-origin_resource_sharing
[elm-serverless]:http://package.elm-lang.org/packages/ktonon/elm-serverless/latest
