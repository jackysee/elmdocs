# DictKeyValues [![Build Status](https://travis-ci.org/dustinspecker/dict-key-values.svg?branch=master)](https://travis-ci.org/dustinspecker/dict-key-values)
> Swap the key value pairs of a Dict

## Install

```bash
elm-package install dustinspecker/dict-key-values
```

## Usage

```elm
module AwesomeModule where

import Dict
import DictKeyValues

people =
  Dict.fromList [ ("Bob", 3), ("Jan", 7) ]

DictKeyValues.swap people -- Dict.fromList [ (3, "Bob"), (7, "Jan") ]
```

## License
MIT © [Dustin Specker](https://github.com/dustinspecker)
