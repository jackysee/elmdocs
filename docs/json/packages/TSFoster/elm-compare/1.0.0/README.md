# elm-compare

DSL for creating comparison functions in [Elm][elmlang].

[elmlang]: http://elm-lang.org/


## Usage

Install the package:

```shell
elm package install TSFoster/elm-compare
```

Comparing records:

```elm
import Compare exposing (thenBy, thenByReverse, ascending, descending)

winner =
    let
        compare =
            Compare.by .pokerSkill thenBy .cardShufflingAbility ascending
    in
        case compare player opponent of
            EQ ->
                Nothing
            LT ->
                Just opponent
            GT ->
                Just player


rankings =
    List.sortWith
        (Compare.with rockPaperScissors thenBy .age descending)
        allPlayers


addressBook =
    List.sortWith
        (Compare.by .lastName thenBy .firstName thenByReverse .dateOfBirth ascending)
        allContacts
```

For full documentation, see [package.elm-lang.org][package-doc].

[package-doc]: http://package.elm-lang.org/packages/TSFoster/elm-compare/latest


# [Tests](/tests)

```shell
git clone https://github.com/TSFoster/elm-compare.git
cd elm-compare
elm-test
npm install -g elm-doc-test && elm-doc-test && elm-test tests/Doc/Main.elm
```

# License

[MIT](/LICENSE)
