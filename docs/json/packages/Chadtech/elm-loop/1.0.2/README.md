# Elm Loop

This is just an elm lang implementation of the while loop, typical to many C syntax languages. It exposes `while` and `until`.

```javascript
var index = 0;
while (index < 100) {
  index++;
}
```

..can be expressed in Elm as..

```elm
Loop.while ((>) 100) 0 ((+) 1)
```

Check out the find primes example in the examples folder to see a realistic application of this package.

# Think twice before using this package.

You probably dont need this package. You should be mapping, folding, and using recursion most of the time. Make sure you really need a while loop before using this package. If you need to transform all the values in a list, use a map. If you need to collapse all the values in a list, use a fold. Even my find primes example could be accomplished with `List.range` and `List.filter`. Use a while loop if and only if you need to do recusrion, and the condition logic that determines whether to  continue the recursion is super complicated and involves many variables.