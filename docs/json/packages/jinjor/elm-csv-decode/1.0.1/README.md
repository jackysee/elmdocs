elm-csv-decode
====

[![Build Status](https://travis-ci.org/jinjor/elm-csv-decode.svg)](https://travis-ci.org/jinjor/elm-csv-decode)

A CSV decoder for Elm. This library internally uses [lovasoa/elm-csv](http://package.elm-lang.org/packages/lovasoa/elm-csv/latest) for parsing. If you want to know how it parses CSV, visit it.

```elm
-- Now we are going to decode each record as User type.
type alias User =
    { id : String
    , name : String
    , age : Int
    , mail : Maybe String
    }


-- You define decoder with type `Decoder User`
userDecoder : Decoder User
userDecoder =
    succeed User
        |= field "id"
        |= field "name"
        |= int (field "age")
        |= optional (field "mail")


-- This is the source formed of CSV.
source : String
source =
    """
id,name,age,mail
1,John Smith,20,john@example.com
2,Jane Smith,19,
"""


-- Run decoder.
> CsvDecode.run userDecoder source
Ok
    [ { id = "1", name = "John Smith", age = 20, mail = Just "john@example.com" }
    , { id = "2", name = "Jane Smith", age = 19, mail = Nothing }
    ]
```

Pipeline interface is inspired by [elm-tools/parser](http://package.elm-lang.org/packages/elm-tools/parser/latest/Parser).


## LICENSE

BSD-3-Clause
