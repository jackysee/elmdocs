# Elm helpers for working with Jwt tokens.

A collection of Elm Http and Json decoder functions to support Jwt authentication.

## Version 3.0.0 (Elm 0.18)

The one breaking change is the removal of `getWithJwt` (use `Jet.get` instead).

Elm 0.17 users should use version 2.0.0.

## Version 2.0.0 (Elm 0.17)

The one breaking change is that authenticate now returns `Task JwtError String` rather than `Task never (Result JwtError String)`. It is better to leave it to the user to handle the conversion to a Cmd.

Elm 0.16 users should use version 1.0.2.

## Examples

[Examples](https://github.com/simonh1000/elm-jwt/tree/master/examples) are included of the software working with Phoenix and Node backends. More discussion of the Phoenix example can be found in this [blog post](http://simonh1000.github.io/2016/05/phoenix-elm-json-web-tokens/).
