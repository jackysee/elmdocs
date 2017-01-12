# elm-graphql

This library provides support functions used by [elm-graphql](https://github.com/jahewson/elm-graphql),
the GraphQL code generator for Elm.

After the upgrade for 0.18. The generated code should be updated as well but I don't know TypeScript(The generator side is written on TypeScript)

After upgrade it only support POST method(Elm package side. The generator side still send GET when it is fetching Schema). 

It's totally doable to support other HTTP method but I want to make sure the POST method works in the right right way first.

