[![Build Status](https://travis-ci.org/Gizra/elm-editable-webdata.svg?branch=master)](https://travis-ci.org/Gizra/elm-editable-webdata)

EditableWebData
========

> An EditableWebData represents an [Editable](http://package.elm-lang.org/packages/stoeffel/editable/latest) value, along with [WebData](http://package.elm-lang.org/packages/krisajenkins/remotedata/latest).

Similar to the example in [Gizra/elm-storage-key](https://github.com/Gizra/elm-storage-key#storagekey) lets imagine a Todo list
that can be edited. And lets assume that while a todo item is being edited, or while it's being saved,
we'd like to keep showing the original value.

Here's a pattern we may use to solve this:

```elm
import EveryDictList
import StorageKey

type alias TodoItem =
    String


{-| Wrap our `TodoItem` with `EditableWebData`, thus making it have the ability
of having an "original" vs "new" values, and also maintain the `WebData` state.
-}
type alias EditableWebDataTodoItem =
    EditableWebData TodoItem


{-| The TodoItem ID is type safety.
-}
type TodoItemId
    = TodoItemId Int


{-| We wrap the `ArticleId` with the `StorageKey`.
-}
type alias StorageKeyTodoItem =
    StorageKey TodoItem


{-| We use `EveryDictList` as we want to maintain the order of the items.
-}
type alias EveryDictListTodoItems =
    EveryDictList StorageKeyArticle EditableWebDataTodoItem


type alias Todo =
    { label : String
    , items : EveryDictListTodoItems
    }
```

## Installation

`elm-package install Gizra/elm-editable-webdata`

## Tests

Install packages: `npm install -g elm-test elm-verify-examples`

Execute tests: `./execute-tests`
