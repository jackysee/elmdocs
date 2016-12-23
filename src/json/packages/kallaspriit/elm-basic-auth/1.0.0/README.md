Elm basic auth utility
======================

A helper library for Elm that provides building basic authentication token and header.

## Usage

Add the import to the module where you need to provide a http basic authentication header.

```elm
import BasicAuth
```

To build a Http.Header use

```elm
buildAuthorizationHeader : String -> String -> Http.Header
buildAuthorizationHeader "username" "password"
```

Or to build just the authentication token string

```elm
buildAuthorizationToken : String -> String -> String
buildAuthorizationToken "username" "password"
```
