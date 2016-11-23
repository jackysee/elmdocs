# PorterStemmer

Elm implementation of the classical Porter Stemming-algorithm. The algorithm
is described in [this paper](http://tartarus.org/martin/PorterStemmer/def.txt) 
and on [Wikipedia](https://en.wikipedia.org/wiki/Stemming). 
The implementation is inspired by the [JavaScript](http://tartarus.org/martin/PorterStemmer/js.txt)- 
and the [Haskell](http://tartarus.org/martin/PorterStemmer/haskell.txt)-implementation.

The module exposes a single function.

## stem

The stem-function takes a word and returns its stem. 

    stem "sky" == "sky"
    stem "hopefulness" == "hope"