elm-router
==========

## Install

```bash
$ elm-package install poying/elm-router
```

## Example

```elm
module Main where


import Result
import String
import Dict exposing (Dict)
import Router exposing ((:~>), (:=>))
import Router.Parameter exposing ((/:), int, string)
import Graphics.Element exposing (show)


type Page
  = Home
  | Article String Int
  | AdminHome
  | NotFound


match =
  Router.match router NotFound


router =
  [ "/" :~> always Home
  , "/user/:uid/article/:aid" :~> always Article /: string "uid" /: int "aid"
  -- nested router
  , "/admin" :=> adminRouter
  ]


adminRouter =
  [ "/" :~> always AdminHome
  ]


main =
  show <|
    case match "/user/poying/article/123" of
      Home -> "Home"
      AdminHome -> "AdminHome"
      Article uid aid -> "Article " ++ uid  ++ " " ++ toString aid
      NotFound -> "NotFound"
```

## License

(The MIT License)

Copyright (c) 2016 Po-Ying Chen <poying.me@gmail.com>.
