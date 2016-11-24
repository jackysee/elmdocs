# elm-simple-data
A collection of methods for dealing with data and simplifying converting between differnet types.

At the moment Convert provides ways of attempting to convert data, with some default to return if it fails.

Convert exposes two methods, `defaultResult` and `defaultMaybe`. These can be used to either pull out `Ok x` or `Just x`, but default to value passed in. This is useful in a few cases, unwanted in most other cases however.


Working with values (String) in your views that are Ints in your models

```

type Number = Hour Int
hoursView : Signal.Address Update -> Html.Html
hoursView address = 
  numberSelectView 
    [on "input" targetValue (Signal.message address << AlarmTime << Hour << String.attemptToInt 0)] 
    0
    23
```
