elm-test-extra
==============

[![CircleCI](https://circleci.com/gh/ktonon/elm-test-extra.svg?style=svg)](https://circleci.com/gh/ktonon/elm-test-extra)

Extra expectations, fuzzers, testers and describers.

`elm package install` [ktonon/elm-test-extra][]

## Example: Describing JSON Decoders

Write concise test for JSON decoders.

Use the high level `describeDecoder` to quickly write tests that exercise a `Json.Decode.Decoder`. For example,

```elm
describeDecoder "int"
  Json.Decode.int
  [ ( "", FailsToDecode )
  , ( "\"foo\"", FailsToDecode )
  , ( "1", DecodesTo 1 )
  , ( "1.5", FailsToDecode )
  , ( "\"this-will-fail\"", DecodesTo 5)
  ]
```

In this example, the last test will fail, giving helpful feedback:

```
↓ int
✗ this-will-fail DecodesTo 5

    Expected input:
      this-will-fail
    to decode successfully, but instead it failed with message:
      Expecting an Int but instead got: "this-will-fail"
```

[ktonon/elm-test-extra]:http://package.elm-lang.org/packages/ktonon/elm-test-extra/latest
