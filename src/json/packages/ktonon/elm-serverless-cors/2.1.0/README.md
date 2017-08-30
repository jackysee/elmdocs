# elm-serverless-cors

[![serverless](http://public.serverless.com/badges/v3.svg)](http://www.serverless.com)
[![Elm Package](https://img.shields.io/badge/elm-1.0.1-blue.svg)](http://package.elm-lang.org/packages/ktonon/elm-serverless-cors/latest)
[![CircleCI](https://img.shields.io/circleci/project/github/ktonon/elm-serverless-cors.svg)](https://circleci.com/gh/ktonon/elm-serverless-cors)

This is [CORS][] middleware for [elm-serverless][].

There are two ways to use it.

1. Set the headers that you need, individually.
2. Set the headers using externally provided configuration.

## Method 1

Set the headers that you need, individually.

```elm
import Serverless.Conn.Request exposing (Method(..))
import Serverless.Cors exposing (..)
import Serverless.Plug exposing (pipeline, plug)


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

## Method 2

Set the headers using externally provided configuration (i.e. AWS Environment variables), and decode them into your app's config record. This method is demonstrated in [elm-serverless-demo][]. In summary, you need to do the following.

First add CORS configuration to your Serverless app's `Config` type. And decode it with the provided `Cors.configDecoder`.

```elm
import Json.Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required, decode, hardcoded)
import Serverless.Cors as Cors


type alias Config =
    { cors : Cors.Config
    -- ...
    }


configDecoder : Json.Decode.Decoder Config
configDecoder =
    decode Config
        |> required "cors" Cors.configDecoder
        -- ...
```

Then you can access the config from your `Conn` and use it to configure CORS.

```elm
import Serverless.Conn exposing (config)
import Serverless.Plug exposing (pipeline, plug)
import Serverless.Cors exposing (cors)

myPipeline =
    pipeline
        |> plug (Cors.fromConfig .cors)
```

On the JavaScript side, you can do something like this to map AWS Lambda environment variables to a JavaScript object.

```javascript
const elmServerless = require('elm-serverless');
const rc = require('strip-debug!shebang!rc');

const elm = require('./API.elm');

// Use AWS Lambda environment variables to override these values
// See the npm rc package README for more details
const config = rc('myApi', {
  cors: {
    origin: '*',
    methods: 'get,post,options',
  },
});

module.exports.handler = elmServerless.httpApi({
  handler: elm.API,
  config,
});
```

So in the [AWS Lambda console][], you can set environment variables, which will get loaded by [rc][] into a JavaScript configuration object, and passed into elm for decoding. In this example, you could set

* `myApi_cors__origin=foo.com,bar.com`: decodes to `Exactly ["foo.com", "bar.com"]` for `origin`
* `myApi_cors__credentials=true`: decodes to `True` for `credentials`

[AWS Lambda console]:https://console.aws.amazon.com/lambda/home
[CORS]:https://en.wikipedia.org/wiki/Cross-origin_resource_sharing
[elm-serverless]:http://package.elm-lang.org/packages/ktonon/elm-serverless/latest
[elm-serverless-demo]:https://github.com/ktonon/elm-serverless-demo
[rc]:https://www.npmjs.com/package/rc#standards
