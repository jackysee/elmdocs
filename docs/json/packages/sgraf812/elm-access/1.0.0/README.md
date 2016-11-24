# Access

As I just realized, I 'reinvented' Evan's [Focus](http://package.elm-lang.org/packages/evancz/focus/1.0.1) library and he's done a great job at giving an introduction. 

A quick comparison to what this library handles differently:

  - + Since `Accessor`s are just aliases for functions, libraries can provide `Accessor`s without actually depending on this library!
  - + Updates may also change the type of the smaller thing
  - - Doesn't have the same level of neatness as Evan's API
  - - Possibly more complex because of more type parameters

Meanwhile I decided to use Evan's library for my simple purposes. I'll upload this library anyway, only to give others polymorphic lenses if they need them. 
`Accessor`s are just generalized getters and setters for arbitrary structures and their parts. This aims to be a simple version of [lenses](https://hackage.haskell.org/package/lens).
