# elm-convert-units
Elm library for converting between quantities in different units. Inspired by https://github.com/ben-ng/convert-units

# Usage
```
import ConvertUnits exposing (convert, describe, possibilities, isPossible)
import ConvertUnits.Definitions exposing (Category(Area), Descriptor)

oneMeterToFoot : Result String Float
oneMeterToFoot = convert 1.0 "m" "ft"

tenKgToOz : Result String Float
tenKgToOz = convert 10.0 "kg "oz"

inches : Maybe Descriptor
inches = describe "in" // == { abbr: "in" , singluar: "Inch", plural: "Inches", toAnchor : (1 / 12) }

canPixels : Bool
canPixels = isPossible "px" // == False

areaUnits : List String
areaUnits = possibilities Area // == [ "mm2", "cm2", "m2", "ha", "km2", "in2", "ft2", "ac", "mi2" ]

```
