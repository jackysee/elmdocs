
# elm-prismicio

An Elm SDK for [Prismic.io](https://prismic.io).

For a complete [example application](http://blog.mattjbray.com/elm-prismicio),
check out the `examples/` directory of this repo.

## Set up

First, you need to initialise the Prismic `Model`.

```elm
import Prismic as P

type alias Model =
    { prismic : P.Model
    , response : Maybe (P.Response P.DefaultDocType)
    }


init =
    let
        model =
            { prismic =
                P.init (Url "https://lesbonneschoses.prismic.io/api")
            , response =
                Nothing
            }
    in
        ( model, fetchHomePage model.prismic )
```


## Querying Prismic

To make a Prismic request, you need to do four things:

1. Make sure we have fetched the API.
2. Select a Form.
3. Optionally customise the Form's query.
4. Submit the Request, providing a JSON decoder to decode the documents in the
   result.

In practice, it will look something like this:

```elm
type Msg
    = SetPrismicError P.PrismicError
    | SetHomePage ( P.Response P.DefaultDocType, P.Model )


fetchHomePage prismic =
    P.api prismic
      |> P.form "everything"
      |> P.bookmark "home-page"
      |> P.submit P.decodeDefaultDocType
      |> Task.perform SetPrismicError SetHomePage
```


When you handle `SetHomePage` in your app's `update` function, you should
replace the `prismic` value in your model with the one returned in the tuple.

```elm
update msg model =
    case msg of
        SetHomePage ( response, prismic ) ->
            ( { model
                  | prismic =
                      P.collectResponses model.prismic prismic
                  , response =
                      response
              }
            , Cmd.none
            )
```
                
If you have nested components that use Prismic, you'll need to thread the
Prismic `Model` through your `init` and `update` functions. See the use of the
`GlobalMsg` type in the `examples/` directory for one way of doing this.

## Custom document types

You can and should define your own Elm record type for each of your Prismic
document types. You'll also need to define a decoder for each of your Elm record
types, and pass it to `Prismic.submit` so that the JSON document can be
marshalled into your Elm record type.

See [examples/les-bonnes-choses/src/App/Documents](examples/les-bonnes-choses/src/App/Documents)
for some examples.
