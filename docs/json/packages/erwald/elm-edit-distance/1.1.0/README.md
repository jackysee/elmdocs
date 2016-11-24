# Edit Distance

An Elm package for calculating between-list edit distances.

It can calculate both the [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between two lists and the actual edit steps required to go from one list to another (using the [Wagner-Fischer algorithm](https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm)).


```elm
-- Levenshtein.
levenshtein (String.toList "kitten") (String.toList "sitting") == 3
levenshteinFromStrings "garvey" "avery" == 3

-- Edit steps.
edits (String.toList "kitten") (String.toList "sitting") ==
  [ Substitute 's' 0
  , Substitute 'i' 4
  , Insert 'g' 6
  ]

editsFromStrings "sitting" "kitten" ==
  [ Substitute 'k' 0
  , Substitute 'e' 4
  , Delete 'g' 6
  ]

-- Edit steps include moves (i.e. deletions followed by insertions).
editsFromStrings "garvey" "avery" ==
  [ Delete 'g' 0
  , Move 'r' 2 3
  ]
```

The resulting indices reflect edits where *deletions are made first*, before insertions and substitutions. That is, indices for deletions refer to the source list, whereas indices for insertions and substitutions refer to the latter, intermediate lists.

An example will serve. Calling `editsFromStrings` with `"preterit"` and `"zeitgeist"` returns the following:

```elm
[ Substitute 'z' 0
, Delete 'r' 1
, Insert 'i' 2
, Insert 'g' 4
, Delete 'r' 5
, Insert 's' 7
]
```

Let's look at these steps in order, keeping in mind that deletions are made first:

1. Deleting at index 1 in "p**r**eterit" gives "peterit".
2. Deleting at index 5 in "prete**r**it" gives "peteit".
3. Substituting "z" at index 0 in "**p**eteit" gives "**z**eteit".
4. Inserting "i" at index 2 in "zeteit" gives "ze**i**teit".
5. Inserting "g" at index 4 in "zeiteit" gives "zeit**g**eit".
6. Inserting "s" at index 7 in "zeitgeit" gives "zeitgei**s**t".

## To do

* [x] String support.
* [x] Custom cost function.
* [ ] Memoization.

## Tests

First compile the tests:

```sh
$ cd tests

$ elm-make Tests.elm
Success! Compiled 0 modules.
Successfully generated index.html
```

Then open up `index.html` and have a look at the console. It should say something like this:

```
1 suites run, containing 14 tests
All tests passed
```

## Contributing

Contributions are welcome. Just open up an issue if you've found a problem or have a suggestion for a feature, or a pull request if you already know how to fix or implement it.

## Changelog

### 1.1.0

* Adds support for custom cost functions in the form of `editsWithCostFunc` and `editsWithCostFuncFromStrings`.

### 1.0.0

* Initial version, with support for calculating Levenshtein distance and edit steps using the Wagner-Fischer algorithm. Also includes String support.
