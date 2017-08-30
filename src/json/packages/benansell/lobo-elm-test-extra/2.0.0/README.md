# lobo-elm-test-extra [![Build status](https://ci.appveyor.com/api/projects/status/qxt50hly0sq9cjcs/branch/master?svg=true)](https://ci.appveyor.com/project/benansell/lobo-elm-test-extra/branch/master) [![Build Status](https://travis-ci.org/benansell/lobo-elm-test-extra.svg?branch=master)](https://travis-ci.org/benansell/lobo-elm-test-extra)

Additions to [elm-test](http://package.elm-lang.org/packages/elm-community/elm-test/latest) for use with the [lobo](https://github.com/benansell/lobo) test runner.

    skippedTest : Test
    skippedTest =
        skip "ignore test" <|
            test "skippedTest" <|
                \() ->
                    Expect.fail "Never runs"

## Migration from elm-test
To use this package you will need to use lobo with the "elm-test-extra" framework, and replace:
```elm
import Test
```
with
```elm
import ElmTest.Extra
```
Further information on using lobo can be found [here](https://github.com/benansell/lobo)

The following elm-test functions are not available in elm-test-extra:
* concat -> instead use `describe`

Note: the use of skip in lobo requires a reason to be specified
