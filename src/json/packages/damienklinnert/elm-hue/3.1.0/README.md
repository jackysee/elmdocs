# elm-hue [![Build Status](https://travis-ci.org/damienklinnert/elm-hue.svg?branch=master)](https://travis-ci.org/damienklinnert/elm-hue)

Control your Philips Hue devices with Elm!

The `Hue` module provides a simple way to query and control your Philips Hue devices from
your Elm application. It empowers you to build a UI for controling your lights in almost no time!

- [license](https://github.com/damienklinnert/elm-hue/issues/blob/master/LICENSE)
- [bug tracker](https://github.com/damienklinnert/elm-hue/issues)
- [source code](https://github.com/damienklinnert/elm-hue)
- [documentation](http://package.elm-lang.org/packages/damienklinnert/elm-hue/latest/)


## Quickstart

This section will walk you through your very first steps with the `Hue` module. At the end, you'll
have a good understanding of how to use this module.

You can find a [complete and working example](https://github.com/damienklinnert/elm-hue/blob/master/src/Hue.elm) in the
`example` folder.

### Preparation: Obtaining Base Url and Username

Before we get started, you'll need to obtain two pieces of information: the **base url** of your
bridge and a valid **username**. If you already have those, you can skip this section. Otherwise
keep reading.

There's a [great cli tool for setting everything up written in ruby](https://github.com/birkirb/hue-cli)
Simply run the following commands to obtain your base url and username.

```bash
gem install hue-cli
hue register
# take a note of the username (the part in brackets), e.g. D4yG2jaaJRlKWriuoeNyD25js8aJ53lslaj73DK7
hue | grep IP
# take a note of the ip and append http://, e.g. http://192.168.1.1
```


### Referencing Your Bridge

In order to communicate with the bridge, we'll need a reference first:

```elm
baseUrl =
    "http://192.168.1.1"


username =
    "D4yG2jaaJRlKWriuoeNyD25js8aJ53lslaj73DK7"


myBridge =
    Hue.bridgeRef baseUrl username
```

### Listing Available Lights

We can use the bridge reference to list all available lights by calling `listLights`. Don't forget
to pass the returned `Cmd` to your `program`.

```elm
listLightsTask : Task.Task Hue.Errors.BridgeReferenceError (Result (List Hue.Errors.GenericError) (List Hue.LightDetails))
listLightsTask =
    Hue.listLights myBridge
        |> Task.map (Debug.log "light details")
        >> Task.mapError (Debug.log "an error occured")


listLightsCmd : Cmd Msg
listLightsCmd =
    Task.perform (always Noop) (always Noop) listLightsTask
```

If everything goes well the output will look similar to this:

```
lights:
  [ { id = "5"
  , name = "Hue color lamp 1"
  , uniqueId = "00:93:12:01:00:fb:3a:ff-0b"
  , bulbType = "Extended color light"
  , modelId = "LCT001"
  , manufacturerName = "Philips"
  , softwareVersion = "66009663"
  } ]
```

If you see an error, make sure that:

 - you're still in the same network as the bridge
 - both baseUrl and username have the correct format


### Updating Light State

We can use one of the light ids to create a reference to it like this:

```elm
myLight =
    Hue.lightRef myBridge "3"
```

This light reference allows us to control the light. Here's some example code that can be used to toggle the light on/off
every 4 seconds. Don't forget to wire it up to your program though.

```elm
turnOnTask =
    Hue.updateLight myLight [ Hue.turnOn ]
        |> Task.map (Debug.log "turned light on")
        >> Task.mapError (Debug.log "an error occured")


turnOffTask =
    Hue.updateLight myLight [ Hue.turnOff ]
        |> Task.map (Debug.log "turned light off")
        >> Task.mapError (Debug.log "an error occured")


turnOnCmd : Cmd Msg
turnOnCmd =
    Task.perform (always Noop) (always Noop) turnOnTask


turnOffCmd : Cmd Msg
turnOffCmd =
    Task.perform (always Noop) (always Noop) turnOffTask


toggleEvery4Seconds : Sub Msg
toggleEvery4Seconds =
    Time.every (4 * Time.second) (always ToggleCmd)

```


### Errors

Handling errors with the Hue system is often a challenge.

1. You can have errors sending commands to the bridge from bad network conditions, unplugged bridge, not authorized on bridge, etc.

2. When you do successfully send commands to a bridge, a list of errors can be returned from the bridge. A list of errors can also be returned with a list of successful updates. 
There are multiple different error types that can come back depending on the command sent and the bridge state. 
 
This library aims to make that process easier by relying on the fantastic type system. First we separate errors into two main categories.

1. Bridge communication failures. Any issues communicating with a bridge will fail the `Task` with a `BridgeReferenceError` type that will contain the case of the failure.

```elm
case error of
    UnauthorizedUser info ->
        -- Not authorized on bridge

    Timeout ->
        -- Network timed out

    NetworkError ->
        -- Network error
```

2. Errors returned from the bridge. When a `Task` successfully communicated with the bridge, a `Result` is returned containing
a list of bridge errors in the `Err` tag and the successful query data in the `Ok` tag.

```elm
case response of
    Result.Ok lights ->
        -- Successfully got a list of lights as from the bridge

    Result.Err errors ->
        -- Bridge did not return a list of lights, but a list of errors instead
```

Things are further separated by the kinds of errors that can be returned. 

1. Generic Errors. Certain error types, such as `InternalError` can be returned from different commands when the
 bridge has some sort of error. This is classified as a `GenericError` that may come back from any command.

2. Command Specific Errors. Certain error types can only be returned from specific commands. For example, updating a light can not 
return any error types about groups, but it can return a `DeviceTurnedOff` error type. When updating a light state, only the possible error
types returned from the bridge are contained in a `UpdateLightError`. That way you only have to think about the possible errors that might come back.

### What's next?

- You can find a [complete and working example](https://github.com/damienklinnert/elm-hue/blob/master/src/Hue.elm) in the
`example` folder.
- Check out the other functions on the [Hue module](http://package.elm-lang.org/packages/damienklinnert/elm-hue/latest/Hue)
- build yourself a powerful UI for controling your own lights.

## Notes

- Minimum Hue Bridge version supported is v1.4

## Contributors

Thanks to all contributors:

- Michael Torres