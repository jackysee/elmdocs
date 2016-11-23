# IsFibonacciNumber [![Build Status](https://travis-ci.org/dustinspecker/is-fibonacci-number.svg?branch=master)](https://travis-ci.org/dustinspecker/is-fibonacci-number)
> Determine if an Int is a Fibonacci Number

## Install

```bash
elm-package install dustinspecker/is-fibonacci-number
```

## Usage

```elm
module AwesomeModule where

import IsFibonacciNumber

validateNumber : Int -> Bool
validateNumber n =
  IsFibonacciNumber.test n

validateNumber -3 -- False
validateNumber  0 -- False
validateNumber  3 -- True
validateNumber 13 -- True
```

## License
MIT © [Dustin Specker](https://github.com/dustinspecker)
