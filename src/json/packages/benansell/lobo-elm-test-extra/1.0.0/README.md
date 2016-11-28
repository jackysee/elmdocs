# lobo-elm-test-extra

Additions to [elm-test](http://package.elm-lang.org/packages/elm-community/elm-test/latest) for use with the [lobo](https://github.com/benansell/lobo) test runner.

    skippedTest : Test
    skippedTest =
        skip "ignore test" <|
            test "skippedTest" <|
                \() ->
                    Expect.fail "Never runs"


    focusTest : Test
    focusTest =
        focus <|
            test "Example passing test" <|
                \() ->
                    Expect.pass

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
* filter -> instead use `skip`