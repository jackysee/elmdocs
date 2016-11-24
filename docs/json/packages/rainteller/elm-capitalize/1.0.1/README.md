# elm-capitalize [![Build Status](https://travis-ci.org/rainteller/elm-capitalize.svg?branch=master)](https://travis-ci.org/rainteller/elm-capitalize)

Capitalize a string.

## Install
```bash
$ elm package install rainteller/elm-capitalize
```

## Usage
Import the package
```elm
import Capitalize
```

Capitalize only the first word of a sentence.
```elm
Capitalize.toCapital "hello world"  -- "Hello world"
```

Capitalize each word of a sentence.
```elm
Capitalize.toCapitalAll "hello world"  -- "Hello World"
```
