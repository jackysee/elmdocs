# StringDistance

A library to calculate a metric indicating the string distance between two strings

* sift3Distance

It also exposes two utility functions for finding general Longest Common Subsequence.

* lcs
* lcsLimit

StringDistance was extracted from the port of mailcheck.js to Elm which is https://github.com/rluiten/mailcheck.

The mailcheck library refers to http://siderite.blogspot.com.au/2007/04/super-fast-and-accurate-string-distance.html as source of string distance algorithm.

## Testing

This uses elm-test for testing so install it if you dont have it.

* npm install -g elm-test

To run Tests

* elm-test

Copyright (c) 2016 Robin Luiten
