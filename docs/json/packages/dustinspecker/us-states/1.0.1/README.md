# UsStates [![Build Status](https://travis-ci.org/dustinspecker/us-states.svg?branch=master)](https://travis-ci.org/dustinspecker/us-states) [![Elm Docs](https://img.shields.io/badge/elm-docs-brightgreen.svg)](http://package.elm-lang.org/packages/dustinspecker/us-states/latest)
> Get US state name from an abbrevation and vice versa.

## Install

```bash
elm-package install dustinspecker/us-states
```

## Usage

```elm
module AwesomeModule where

import UsStates

UsStates.fromAbbr "zZ" -- Nothing
UsStates.fromAbbr "mo" -- Just "Missouri"
UsStates.fromAbbr "RI" -- Just "Rhode Island"

UsStates.toAbbr "Igloo" -- Nothing
UsStates.toAbbr "Missouri" -- Just "MO"
UsStates.toAbbr "Rhode Island" -- Just "RI"
```

## License
MIT © [Dustin Specker](https://github.com/dustinspecker)
