# Arborist
[![Build Status](https://travis-ci.org/SamirTalwar/arborist.svg?branch=master)](https://travis-ci.org/SamirTalwar/arborist)

Arborist is a test framework for asynchronous Elm code.

It is intended for use mostly with Tasks. Tests are defined as assertions on tasks, which are executed in parallel and reported on the command line.

## Installation

You'll need to install [Node.js][] (which is used for running the tests), and the [Elm Platform][].

Once you have both of those, you can install the package:

    elm package install SamirTalwar/arborist

The latest version of Arborist is v1.0.0.

[Node.js]: https://nodejs.org/
[Elm Platform]: http://elm-lang.org/install

## Writing tests

Define a test file as follows, with your own test cases.

```elm
module My.Wonderful.Tests exposing (tests)

import Arborist.Framework exposing (..)
import Arborist.Matchers exposing (..)
import Process
import Task

tests : List Test
tests =
  [
    test "performs simple equality checks" (
      let
        a = True |> Task.succeed
        b = True |> Task.succeed
      in
        assert a (equals b)
    ),

    test "negates matchers" (
      let
        a = True |> Task.succeed
        b = False |> Task.succeed
      in
        assert a (not' (equals b))
    ),

    test "verifies that an integer is between two others" (
      assert (Task.succeed 88) (isIntBetween (Task.succeed 77) (Task.succeed 99))
    ),

    test "waits for tasks to succeed" (
      let
        a = Process.sleep 100 `Task.andThen` always (Task.succeed 42)
        b = Task.succeed 42
      in
        assert a (equals b)
    ),

    test "waits for tasks to fail" (
      let
        a = Process.sleep 100 `Task.andThen` always (Task.fail "Well, that didn't work.")
        b = Task.fail "Well, that didn't work."
      in
        assert (assert a (equals b)) fails
    )
  ]
```

You'll probably find yourself extracting groups of tests out into files as you need. `run` just takes a list of `Test` values, so you can concatenate multiple lists of tests with `List.concat`.

There are a few matchers in Arborist:

  * `equals`
  * `not'`
  * `isIntBetween`

Please submit issues and pull requests with ideas for more!

## Running tests

You'll need to use `node` to run the tests as follows:

	node ./elm-stuff/packages/SamirTalwar/arborist/1.0.0/bin/run My.Wonderful.Tests.tests test/Tests.elm

Arborist compiles the test files for you using `elm make`, so you don't need to add them to your `"source-directories"` section of *elm-package.json*.

As you add more test files, you just need to add them to the end of that command line.

## Contributing

Arborist is bound by the [Contributor Covenant][]. Please raise issues and send pull requests.

[Contributor Covenant]: http://contributor-covenant.org/version/1/4/

## Licence

Arborist is licenced under the [MIT License][].

[MIT License]: https://samirtalwar.mit-license.org/
