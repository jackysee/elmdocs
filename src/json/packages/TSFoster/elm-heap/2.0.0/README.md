# elm-heap

Data structure for heaps, in [Elm][elmlang].

[elmlang]: http://elm-lang.org/


## Usage

Install the package:

```shell
elm package install TSFoster/elm-heap
```

Use the heap:

```elm
import Heap exposing (Heap, smallest, biggest, by, thenBy)

type alias Person =
    { firstname : String
    , surname : String
    , age : Int
    }

init : Heap Person
init = Heap.empty (smallest |> by .surname)

defaultPeople : Heap Person
defaultPeople =
    Heap.fromList (biggest |> by .surname |> thenBy .firstName |> thenBy .age)
        [ { firstname = "Anders", surname = "And", age = 83 }
        , { firstname = "Bruce", surname = "Bogtrotter", age = 8 }
        , { firstname = "Charlie", surname = "Chaplin", age = 88 }
        , { firstname = "Donald", surname = "Duck", age = 83 }
        ]
```

For full documentation, see [package.elm-lang.org][package-doc].

[package-doc]: http://package.elm-lang.org/packages/TSFoster/elm-heap/latest


# [Tests](/tests)

```shell
git clone https://github.com/TSFoster/elm-heap.git
cd elm-heap
elm-test
npm install elm-doc-test && elm-doc-test && elm-test tests/Doc/Main.elm
```

# License

[MIT](/LICENSE)
