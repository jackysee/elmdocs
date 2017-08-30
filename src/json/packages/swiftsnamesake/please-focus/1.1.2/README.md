Focus Please
============
Sort-of lenses. Maybe I'll add _real_ lenses. Maybe I won't.

# Examples
Lenses solve the problem of modifying immutable data structures,
by hiding away the manual destructuring and restructuring behind
a simple interface.

To create a lens, we define a function which _focuses_ on a single piece
of data within a data structure, applying a function to the piece and replacing
the new value with the old.

Most commonly, lenses focus on a single field withing a record, although it's
certainly possible to define lenses for enumerations, numbers, tuples and even
_multiple_ record fields.

You may also define polymorphic lenses. Maybe we'll get back to that later.

Enough chatter, let's define a lens!

```elm
import Focus exposing (..)

-- A seasonal data type
type alias Santa = {
  bag  : List Gift,
  home : Coordinates,
  nickname : String
}

-- Our lens
nickname : Setter Santa Santa String String
nickname f santa = {santa|nickname = f santa.nickname}

-- Setter is a type alias for a kind of function:
type alias Setter s t a b = (a -> b) -> s -> t

-- As the name implies - and unlike proper lenses - it only supports setting values, not getting them.
-- Accessing nested fields is less of a hassle in Elm than it is in Haskell. Still, if I find a simple way
-- of unifying Setters and Getters, I may add a Lens type in the future.

-- Now that we have a Setter, we may use it to change Santa's name
santa = { bag = [], home = Coords (N 66) (E 25), nickname = "St Nick" }

-- Setting the nickname to a new value
santa & nickname .= "Saint Nicholas"

-- Updating the nickname with a function
santa & nickname $= String.toUpper

-- We may also combine two lenses with the 'compose' function,
-- or its infix counterpart (=>)
santa & nickname=>first $= String.toLower

-- Defining 'first' is left as an exercise to the reader.
```
