# effmodel

EffModel embodies a single value that carries both the model and accumulated
effects for a world step in the elm architecture.

The elm architecture is nice, but a tuple of model and effect is troublesome
to compose.  Consider the standard update function:

    update : Action -> Model -> (Model, Effects Action)

In order to compose it, you need to destructure the result, use Effects.batch
on the snd, and map on the first, then combine a new tuple.  EffModel replaces
this process and has functions that construct an effmodel either from a model
or an update result tuple, and that produce an update result tuple from an
EffModel.

I use it extensively like this:

    import EffModel as EF

    handleUpdateForOneLogicalThing : Action -> EffModel Model Action -> EffModel Model Action
    handleUpdateForOneLogicalThing action effmodel =
        case action of
            Increment -> effmodel |> EF.map (\m -> { m | count = m.count + 1 })
            Decrement ->
                effmodel
                    -- Compose model update and an effect conveniently
                    |> EF.map (\m -> { m | count = m.count - 1 })
                    |> EF.eff (Effects.task (Task.sleep (5 * Time.second) `Task.andThen` (\_ -> Task.succeed Increment)))
            _ -> effmodel -- Note that you can just pass it through easily

    handleUpdateForAnotherLogicalThing : Action -> EffModel Model Action -> EffModel Model Action

    update : Action -> Model -> (Model, Effects Action)
    update action model =
        model
           |> wrap
           |> handleUpdateForOneLogicalThing action
           |> handleUpdateForAnotherLogicalThing action
           |> unwrap

