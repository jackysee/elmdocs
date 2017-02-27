# elm-driveby

opinionated browser testing in elm - experimental work in progress, but usable


### Why? ###
1. light touch - just depends on phantomjs and embedded driveby.js
2. implicit waiting
3. parallel execution


### Setup ###
1. ```elm-package install alltonp/elm-driveby```
2. [download a phantomjs executable](http://phantomjs.org/download.html)
3. That's it!


### Running example scripts ###
(1) ```cd elm-stuff/packages/alltonp/elm-driveby/x.x.x```

(2) build some example apps (slightly tweaked from https://github.com/evancz/elm-architecture-tutorial/)
```
elm-make examples/src/01-button.elm --output examples/build/01-button.html
elm-make examples/src/02-field.elm --output examples/build/02-field.html
```
(3) build the tests
```
elm-make examples/test/*.elm --output tests.js
```
(4) run the tests
```
{path-to-phantom}/phantomjs driveby.js
```

