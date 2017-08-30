# elm-serverless-auth-jwt

[![serverless](http://public.serverless.com/badges/v3.svg)](http://www.serverless.com)
[![CircleCI](https://img.shields.io/circleci/project/github/ktonon/elm-serverless-auth-jwt/master.svg)](https://circleci.com/gh/ktonon/elm-serverless-auth-jwt)

This is authorization middleware for [elm-serverless][] using [JSON Web Tokens][].

## Example

See the [demo](https://github.com/ktonon/elm-serverless-auth-jwt/blob/master/demo/src/Auth/API.elm)
for a complete usage example.

To run the demo

```shell
npm install
npm start
```

and visit http://localhost:3000. Use [curl][] or [Postman][] to set an `Authorization` header to `Bearer SOME_JWT_TOKEN`. The demo secret is `"secret"`. You can change the secret by setting the environment variable `demoAuth_auth__secret`, before running `npm start`.

[curl]:https://curl.haxx.se/docs/manpage.html
[elm-serverless]:http://package.elm-lang.org/packages/ktonon/elm-serverless/latest
[JSON Web Tokens]:https://jwt.io/
[Postman]:https://www.getpostman.com/
