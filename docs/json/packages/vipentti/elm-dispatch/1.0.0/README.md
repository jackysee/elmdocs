# elm-dispatch

Dispatch multiple messages in response to a single `Html.Event`. 

UI libraries in elm sometimes need to perform internal actions on `Html.Events` such as `onFocus`, while at the same time allowing library users to also respond to those events. This library provides such multiple dispatch.

## Motivation 

The library was developed for the purpose of allowing [elm-mdl](http://package.elm-lang.org/packages/debois/elm-mdl/latest) to have stateful components such as `Textfield` which also allow user provided event-handlers.

`Textfield` requires some internal state management on `onFocus` and `onBlur` events. However, users may also want to have event-handlers for those particular events and this is where `Dispatch` helps.


## Install

```shell
elm package install vipentti/elm-dispatch
```

## Example

An example of how to use the library may be found in the `examples/` folder.

The library can also been seen in use in [elm-mdl](http://package.elm-lang.org/packages/debois/elm-mdl/latest) specifically [Material.Options.Internal](https://github.com/vipentti/elm-mdl/blob/78ab6b6dc0a8e5044a06d2a3c07fa7d900093585/src/Material/Options/Internal.elm) and [Material.Options](https://github.com/vipentti/elm-mdl/blob/78ab6b6dc0a8e5044a06d2a3c07fa7d900093585/src/Material/Options.elm#L351-L507). 

## License

© Ville Penttinen, 2016. Licensed under an
[Apache-2.0](https://github.com/vipentti/elm-dispatch/blob/master/LICENSE)
license.
