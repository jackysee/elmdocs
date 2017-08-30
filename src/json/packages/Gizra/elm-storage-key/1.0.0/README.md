[![Build Status](https://travis-ci.org/Gizra/elm-storage-key.svg?branch=master)](https://travis-ci.org/Gizra/elm-storage-key)

StorageKey
========

> A StorageKey represents a value that is either New or Existing.

Lets take for example an `Article`. It will have a unique Id, and the article record itself. How would we distinguish between an existing
Article (one that was fetched from the backend) vs a new one, while still having type safety?

Here is how this package helps along with this pattern.

```elm
-- http://package.elm-lang.org/packages/Gizra/elm-dictlist/latest
-- It's like EveryDict, only it will maintain the order as-well.
import EveryDictList

type alias Article =
    { label : String
    , body : String
    }


{-| The Article ID is type safety.
-}
type ArticleId
    = ArticleId Int


{-| We wrap the `ArticleId` with the `StorageKey`.
-}
type alias StorageKeyArticle =
    StorageKey ArticleId


type alias EveryDictListArticles =
    EveryDictList StorageKeyArticle Article


type alias Person =
    { name : String
    , articles : EveryDictListArticles
    }
```


## Installation

`elm-package install Gizra/Gizra/elm-storage-key`

## Tests

Install package: `npm install -g elm-test`

Execute tests: `./execute-tests`
