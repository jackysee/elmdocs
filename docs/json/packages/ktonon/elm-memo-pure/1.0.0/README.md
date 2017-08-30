# elm-memo-pure

[![elm-package](https://img.shields.io/badge/elm-1.0.0-blue.svg)](http://package.elm-lang.org/packages/ktonon/elm-memo-pure/latest)
[![CircleCI](https://img.shields.io/circleci/project/github/ktonon/elm-memo-pure/master.svg)](https://circleci.com/gh/ktonon/elm-memo-pure)

Single argument function memoization in pure elm.

Motivated by the [deprecation of elm-lang/lazy][]. This library is inspired by [eeue56/elm-lazy][] in that it makes memoization explicit. The memoized function is encapsulated as a `Memo`. Calling a memoized function returns both the result of the original function, and a new `Memo` containing the possibly newly cached result.

See the [documentation][] for examples.

[deprecation of elm-lang/lazy]:https://github.com/elm-lang/lazy/commit/c9c3f8525d22978cd7ee6e463ebf208f30fa1f91
[documentation]:http://package.elm-lang.org/packages/ktonon/elm-memo-pure/latest/Memo
[eeue56/elm-lazy]:http://package.elm-lang.org/packages/eeue56/elm-lazy/latest
