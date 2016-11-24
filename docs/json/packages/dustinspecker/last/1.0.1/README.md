# Last [![Build Status](https://travis-ci.org/dustinspecker/last.svg?branch=master)](https://travis-ci.org/dustinspecker/last) [![Elm Docs](https://img.shields.io/badge/elm-docs-brightgreen.svg)](http://package.elm-lang.org/packages/dustinspecker/last/latest)
> Get the last element from a List.

## Install

```bash
elm-package install dustinspecker/last
```

## Usage

```elm
module AwesomeModule where

import Last

Last.fromList [] -- Nothing
Last.fromList [ 1 ] -- Just 1
Last.fromList [ "yo", "hello" ] -- Just "hello"
```

## License
MIT © [Dustin Specker](https://github.com/dustinspecker)
