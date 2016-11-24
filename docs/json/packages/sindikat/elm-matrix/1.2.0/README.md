A library for fast immutable rectangular matrices. The elements in a matrix must have the same type. The matrices are implemented on top of Elm's built-in arrays: `type alias Matrix a = Array (Array a)`. While all functions in this library preserve the rectangular property of the matrices, this isn't enforced, so make sure you manipulate the matrices using this API and not Array functions.

Geared towards 2D games.

The API is very unstable and will be changed and revamped many times. I am very happy to discuss and accept any ideas, suggestions, and pull requests on the GitHub page:

http://github.com/sindikat/elm-matrix
