# Csv.Decode

CSV decoding, heavily inspired by [url-parser][].

Note this library does not include an underlying CSV parser. It assumes you 
are using something like [periodic/elm-csv][periodic] or 
[lovasoa/elm-csv][lovasoa] to get from `String` to `Csv`, where 
`Csv` is:

    type alias Csv =
      { headers : List String
      , records : List (List String)
      }

This library gets you the rest of the way, to a list of your own types. It also
collects errors together with the index of the record they occurred on.

You can think of this as analogous to `Json.Decode`. It lets you declaratively
convert data from an intermediate representation (`Json.Value` or `Csv`) into
your own types.


## Basic usage

Using `periodic/elm-csv` (which returns a `Result (List String) Csv`):

    Csv.parse rawData |> Csv.Decode.decode myDecoder

Using `lovasoa/elm-csv` (which returns a plain `Csv`):

    Csv.parse rawData |> Csv.Decode.decodeCsv myDecoder

You can define decoders based on field position or on header name. See 
examples in the docs.

[url-parser]: https://github.com/evancz/url-parser

[periodic]: https://github.com/periodic/elm-csv

[lovasoa]: https://github.com/lovasoa/elm-csv
