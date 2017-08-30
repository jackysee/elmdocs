# elm-test-graph
Execution graphs for [elm-test](/packages/elm-community/elm-test/latest). Define a graph of what operations happen and roughly in what order, and we'll generate total orderings from your graph, and execute them. Hopefully, we'll find some errors this way.

For example, consider this execution graph:

                Set.insert 1 → Set.remove 1
              ↗                             ↘
    Set.empty → Set.insert 2 → Set.remove 2 → Set.isEmpty
              ↘                             ↗
                Set.insert 3 → Set.remove 3

We could, for example, execute it in this order:

    empty
      |> insert 1
      |> insert 2
      |> remove 1
      |> insert 3
      |> remove 3
      |> remove 2
      |> Set.isEmpty

But who in their right mind would think of writing a test-case like that? Good thing we have this tool to find some of [the really obscure bugs](https://xkcd.com/1700).

The graph above can be modeled using this code (which also has a bunch of expectations mid-way to make narrowing in on an error easier, if there is one):

    fuzzGraph "Inserting and deleting set elements can be done in almost any order" Set.empty <|
      (empty
        |> insertNodeData 11 (Modify <| Set.insert 1)
        |> insertNodeData 12 (Expect <| (\set -> set |> Set.member 1 |> Expect.true "1 should be a member"))
        |> insertNodeData 13 (Modify <| Set.remove 1)
        |> insertEdge ( 11, 12 )
        |> insertEdge ( 12, 13 )
        |> insertNodeData 21 (Modify <| Set.insert 2)
        |> insertNodeData 22 (Expect <| (\set -> set |> Set.member 2 |> Expect.true "2 should be a member"))
        |> insertNodeData 23 (Modify <| Set.remove 2)
        |> insertEdge ( 21, 22 )
        |> insertEdge ( 22, 23 )
        |> insertNodeData 31 (Modify <| Set.insert 3)
        |> insertNodeData 32 (Expect <| (\set -> set |> Set.member 3 |> Expect.true "3 should be a member"))
        |> insertNodeData 33 (Modify <| Set.remove 3)
        |> insertEdge ( 31, 32 )
        |> insertEdge ( 32, 33 )
        |> insertEdge ( 13, 100 )
        |> insertEdge ( 23, 100 )
        |> insertEdge ( 33, 100 )
        |> insertNodeData 100 (Expect (\set -> set |> Set.isEmpty |> Expect.true "expected set to be empty"))
      )
