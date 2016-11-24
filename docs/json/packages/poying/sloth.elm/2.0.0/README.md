Sloth.elm
=========

[![elm docs](https://img.shields.io/badge/elm--docs-1.0.0-60B5CC.svg)](http://package.elm-lang.org/packages/poying/sloth.elm/1.0.0/)
[![npm package](https://img.shields.io/npm/v/sloth.elm.svg)](npmjs.com/sloth.elm)

Sloth is a testing framework for Elm. It is inspired from the Node.js module [Mocha](https://github.com/mochajs/mocha).

```elm
module MyTest where


import Sloth exposing (..)
import Sloth.Assertion exposing (..)


tests =
  start
    `describe` "description"
      `it` "should pass" =>
        (1 `shouldBe` 1)
      `it` "should fail" =>
        (1 `shouldNotBe` 1)
    `end` 1
```

## Quick start

1. Get `sloth` command from [npm](http://npmjs.org):

```bash
$ npm i -g sloth.elm
```

2. Create a folder for test files:

```bash
$ mkdir test
```

3. And use `elm-package` to install `poying/sloth.elm`:

```bash
$ cd test
$ elm-package install poying/sloth.elm
```
