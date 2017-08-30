# elm-loop

These functions are for looping, like the 'while' statement in imperative languages. Don't use these if you can use `map`, `foldl`, or `foldr` instead. Use them only when you need to apply a function to a value while or until a predicate holds. Basically, these functions let you write a recursive function without having to write the recursive part yourself; You have to write only the part that updates the value.
