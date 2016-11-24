elm-css (v3.0.0)
================

A library to create and use css styles in Elm.


Docs :
------
* From : [package.elm-lang.org](http://package.elm-lang.org/packages/dhruvin2910/elm-css/3.0.0)


Package :
---------
* download : [3.0.0](https://github.com/dhruvin2910/elm-css/archive/3.0.0.zip)
* elm package : `elm package install dhruvin2910/elm-css`
* git clone : `git clone https://github.com/dhruvin2910/elm-css.git`


Changelog :
-----------

3.0.0 :
-------
1. Only one Css Node type for all nodes.
2. Generalized assignments, declarations and multiple declarations.
3. Added helpers :
    * `:-` from assignment (alias of **assign**)
      * `(property :- value)`

    * `=>` for block declaration (alias of **declare**)
      * `selector => [declaration]`
      * `@rule => [node]`

    * `==>` for multiple selector declaration (alias of **declares**)
      * `[selector] ==> [declaration]`


2.1.0 :
-------
1. Added `=>` operator for declaration blocks.
2. Added `:-` operator for property : value syntax.
3. DSL like structure.


2.0.0 :
-------
1. All types are now aliases of String. Hence one can opt-in for Css Strings.
2. All valid Css nodes are supported via Css Strings. Which will be improved in
   future releases.
3. Chunk of Css code/snippets from third party library/framework can be included
   via `""" Multiline Strings """`
4. Opted out from primitive type system in favor of a *pluggable* library
   implementation. Type system of Css is hard to replicate because of multiple
   (partial / incorrect) implementations.


1.0.1 :
-------
1. `foldl` for reducing List Rule to String.


1.0.0 :
--------
1. `style` tag.
2. Internal stylesheets using `stylesheet (List Rule)`.
3. Rule Declaration only (currently). No `@rules` and `comments`.
4. Primitive data types only. As in `Tuple`, `String` and `List`.


Todo :
------
* Make README and docs more convincing.