# ListJoinConjunction [![Build Status](https://travis-ci.org/dustinspecker/list-join-conjunction.svg?branch=master)](https://travis-ci.org/dustinspecker/list-join-conjunction)
> Join a List with a conjunction

## Install

```bash
elm-package install dustinspecker/list-join-conjunction
```

## Usage

```elm
module AwesomeModule where

import ListJoinConjunction

formattedString : List String -> String
formattedString conjunction list =
  ListJoinConjunction.make "and" list

formattedString "and" [ "red", "blue" ] -- "red and blue"
formattedString "or" [ "red", "blue", "white" ] -- "red, blue, or white"
```

## License
MIT © [Dustin Specker](https://github.com/dustinspecker)
