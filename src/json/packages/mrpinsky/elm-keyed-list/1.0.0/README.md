# KeyedList

A `KeyedList` is a list that assigns each item a locally unique identifier, which makes it easier to later update or remove items via a `Msg`. It encapsulates the ids, so your `Model` doesn't need to keep track of them.

Instead of
```elm
type alias Model =
    { submodels : List (Int, SubModel)
      uid : Int
      ...
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
	Add submodel ->
	    { model
	        | submodels = (model.uid, submodel) :: model.submodels
		, uid = model.uid + 1
	    }
	
	Update id submsg ->
	    let
		updateHelper (subId, submodel) =
		    if subId == id then
			(subId, SubModel.update submsg submodel)
		    else
			(subId, submodel)
	    in
		{ model | submodels = List.map updateHelper model.submodels }

	Remove id ->
	    let
		removeHelper (subId, _) = subId /= id
	    in
		{ model | submodels = List.filter removeHelper model.submodels }
```
you can write
```elm
type alias Model =
    { submodels : KeyedList SubModel
      ...
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
	Add submodel ->
	    { model | submodels = KeyedList.cons submodel model.submodels ]

	Update key submsg ->
	    { model | submodels = KeyedList.update key (SubModel.update submsg) model.submodels }

	Remove key ->
	    { model | submodels = KeyedList.remove key model.submodels }
```
