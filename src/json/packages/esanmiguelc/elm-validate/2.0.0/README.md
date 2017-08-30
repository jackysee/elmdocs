# elm-validate

Link to package: http://package.elm-lang.org/packages/esanmiguelc/elm-validate

Link to repository: https://github.com/esanmiguelc/elm-validate

Validation library inspired by ecto changeset validations. The idea behind this project is to be able to concatenate validations and ultimately get a `ValidationResult` which provides all of the errors produced by the pipeline, which can then be used in any desired manner.

## The Gist:

You start by adding `beginValidation` which puts your `Model` inside a context that allows it to be piped through all of the validations.

```elm
beginValidation {password = "somepass"}
  |> validateLengthOf .password 8 "Password is too short"
```

Once you are done with it you can pattern match the result like so:

```elm
let
  result =
    beginValidation {email = "email@example.com", password = "somepass"}
      |> validatePresenceOf .email "Email must be present"
      |> validateLengthOf .password 8 "Password is too short"
in
  case result of
    Valid model ->
      {- do stuff with a valid model here -}
      ( model, logUserIn model )
    Err model errors ->
      {- do stuff with the errors here -}
      ( { model | errors = errors }, Cmd.none )
```

## Contributing

After you have read the [Code of conduct](CODE_OF_CONDUCT.md).

1. Fork the repo.
2. Write some tests.
3. Make 'em pass
4. Stuck? Ask a Question!
5. Create a pull request - make sure your tests pass.
6. Have a cup of :coffee:

### Setting up

1. Clone the repository.

```bash
$ git clone git@github.com:esanmiguelc/elm-validate.git
```

2. Make sure you have [npm](https://www.npmjs.com/get-npm) installed.
3. Install dependencies.

```bash
$ npm install
```

4. Run the tests

```bash
$ npm run test
```

