# Elm US State Abbreviations

A simple Elm package for US State abbreviations.


``` Elm
import UsStates exposing (Abbreviation(..))

UsStates.fromString : String -> Maybe Abbreviation
UsStates.toString : Abbreviation -> String

UsStates.fromString "   arizona" == Just AZ -- True
UsStates.toString AZ == "arizona"           -- True

UsStates.all == [ AL, AK, AZ, AR, CA, ... ]
```
