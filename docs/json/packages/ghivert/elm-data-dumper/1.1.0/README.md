# Elm Data Dumper

This package provides facilities to dump data structures in HTML.
Contrary to `Debug.log`, which dump everything to the console, Data.Dumper give colors to the output, and format to be easier to read.
You just have to code the dumper when making your structure, and yay! You can dump freely data structures in HTML!

# An Example?

```elm
import Html exposing (Html)

type alias Location =
  { host : String
  , hostname : String
  , protocol : String
  }

type Locations
  = Nowhere
  | Loc Location

dumpLocation : Location -> Html msg
dumpLocation =
  dumpRecord "Location"
    [ ("host", .host >> dumpString)
    , ("hostname", .hostname >> dumpString)
    , ("protocol", .protocol >> dumpString)
    ]

dumpNestedLocation : Location -> Html msg
dumpNestedLocation =
  dumpNestedRecord 1
    [ ("host", .host >> dumpString)
    , ("hostname", .hostname >> dumpString)
    , ("protocol", .protocol >> dumpString)
    ]

dumpLocations : Locations -> Html msg
dumpLocations locations =
  dumpUnion "Locations" <|
    case locations of
      Nowhere ->
        ("Nowhere", Html.text "")
      Loc location ->
        ("Loc", dumpNestedLocation location)

main : Html msg
main =
  let example = Location "host_" "hostname_" "protocol_" in
  Html.div []
    [ dumpLocation example
    , dumpLocations Nowhere
    , dumpLocations <| Loc example
    ]
```

Turn into this:

![Formatted text in HTML](./assets/pictures/readme-screenshot.png)
