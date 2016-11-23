# Scaffold

## Use this.

1. [Example - Boilerplate](https://github.com/williamwhitacre/scaffold/blob/master/examples/Scaffold-Boilerplate.elm)
2. [Example - Dynamic Counter](https://github.com/williamwhitacre/scaffold/blob/master/examples/Scaffold-DynamicCounter.elm)
3. [Example - Resources](https://github.com/williamwhitacre/scaffold/blob/master/examples/Scaffold-Resources.elm) Now working

Note that Example 3 shows a fully working recursive transformation from data to view using `Resource`, and with delta updates to
the view structure using `Resource.deltaOf` and the `stage` function from `App` in conjunction. Enjoy! :)


## This is not an alternative architecture.

This scaffolding is intended to provide a set of very useful types and DSL libraries to help make your Elm Architecture code softer and more semantically understandable. It incorporates Time as an argument to each user provided function and also provides an optional intermediate `stage` function between `update` and `present` which gives us the opportunity to use memoization, any sorts of expensive view staging algorithms we would only want to do once per atomic batch of updates at the end before viewing, any sorts of view recompute optimizations.


# NOTE:

The remainder of `README.md` is relevant because is has a (probably typo ridden) explanation of some of the rationale. It is not however complete or reviewed thoroughly for correctness at the time of this writing (6 Mar 2016). Significant work will be put in to updating the package overall.

Again, [Example 1 - Boilerplate](https://github.com/williamwhitacre/scaffold/blob/master/examples/Scaffold-Boilerplate.elm), [Example 2 - Dynamic Counter](https://github.com/williamwhitacre/scaffold/blob/master/examples/Scaffold-DynamicCounter.elm), and [Example 3 - Resources](https://github.com/williamwhitacre/scaffold/blob/master/examples/Scaffold-Resources.elm) are *definitely* the best place to play with some working code at the moment.

# What's available?

### Scaffold.App

Contains basic definitions for Progam, ProgramInput, and ProgramOutput. Defines the concepts of TaskDispatchments and ProgramConnectors for routing dataflow at the top level of your program. Defines the needed functions to run programs, route input sequence signals, and route the resulting action lists from output TaskDispatchment signals to destination addresses, the self (this running Program), or error handlers.


    myProgramOutput : ProgramOutput MyAction MyModel MyViewType Error
    myProgramOutput =
      App.defProgram' present stage update model0
      |> App.defSequenceInputs
          [ someVeryImportantBrowserEnvironmentInput
          , someOtherOutsideSignal
          ]
      |> App.run
      |> App.it'sErrorConnector myErrorHandler
      |> App.itself


    main : Signal Html.Html
    main = Signal.map myRootRenderer myProgramOutput.view'


    port sink : Signal (Task z ())
    port sink = App.sink myProgramOutput


_(In Gigan, this was formerly called Gigan.Core.)_

### Scaffold.Machine

Contains basic definition of the Machine. A Machine is just a snapshot of a Program with a really simple instruction library for stepping it, examining it, and committing it's pending TaskDispatchment. Machines are essentially a way to embed programs in other programs responsible for deferring control to them, much like coroutines. Of course, despite these synchronous semantics, we get the fully asynchronous Elm runtime treatment.

This is a good way to build modular programs, and works by adjusting all instances of tasks and actions to _lists of tasks and actions instead_. This gives us the power to provide utilities dispatching, ordering, and executing arbitrary sequences of actions with an easy way to select whether or not atomic execution of a given sequence of actions is required. What that does is it provides us with a way compose actions out of sequences of simpler actions, yielding simpler business logic inside components and a rich world of idioms to explore for the bolder among us, but it still feels and scales the same way as a StartApp application because it's fundamentally still just the Elm Architecture.

_(In Gigan, this was formerly called Gigan.Stem.)_


### Scaffold.Resource

#### Notice

This module is in the midst of a rework to make it friendlier to the Elm Architecture. A couple of
poor design decisions resulting from too much coffee probably have been reversed in the latest
version, **but the documentation should be considered out of date until this notice is removed.**

#### Changes

The current version has removed the un-Elm-like need to configure an address with a given
ResourceBase. In addition, the concepts of `ResourceBase` and `ResourceRecord` have been removed
since they are now redundant. Resource has a Group state, which is very flexible for keeping track
of string keyed trees such as one would typically deal with contacting any JSON API.


_(In Gigan, this was formerly called Gigan.Knowledge.)_


# Can I see how to use it?

I'm working on a comprehensive set of examples. There is one working public example right now.

## Software License

Gigan is released under the BSD3 license. The full text of this license is available in the `LICENSE`
file in the source repository, and it is also available from
[here](https://opensource.org/licenses/BSD-3-Clause).
