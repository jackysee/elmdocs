# Elm-DictSet

An Elm library for creating sets of any type


## Usage

Create a set of any type, for example a record type:

```elm

import DictSet exposing (DictSet)


type alias User =
  { id : Int
  , email : String
  }
  
  
allUsers : List User
  

userSet : DictSet Int User
userSet =
  DictSet.fromList .id allUsers
```
