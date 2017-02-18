# Blackjack
An Elm library providing a few utility functions for a Blackjack application.
It can compare hands and calculate the best score for a player given a set of cards.

## Usage

```elm
import Blackjack exposing (..)

hand1 = newHand
  |> addCardToHand (newCard Seven Diamonds)
  |> addCardToHand (newCard Ten Clubs)
hand2 = newHand
  |> addCardToHand (newCard Five Diamonds)
  |> addCardToHand (newCard Ten Clubs)

isHandBetterThan hand1 hand2 == True
```
