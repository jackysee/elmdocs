**This project is in constant development and should not be considered stable.**

Logoot
---

Simple Logoot implementation.

Logoot is a [Commutative Replicated Data Type][cmrdt] (CmRDT) created to be used by
distributed systems that want to achieve Strong Eventual Consistency (SEC).

[cmrdt]: https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type

This is an implementation of [Logoot-undo][logoot] propose by Stéphane Weiss,
Pascal Urso and Pascal Molli. It still lacks support for undo operations.

[logoot]: https://pdfs.semanticscholar.org/75e4/5cd9cae6d0da1faeae11732e39a4c1c7a17b.pdf

I'm using this for my graduation project, a [P2P collaborative editor][editor].
Check it out.

[editor]: https://github.com/hugobessaa/editor

## Installing

Run inside your project directory:

```bash
elm package install hugobessaa/elm-logoot
```

## Examples

In a Logoot, as in other CmRDTs, all operations commute. That is: any operation
available can be executed in any order and the result will be the same. The
classic "changing the order of the operands does not change the result".

```elm
import Logoot exposing (empty, insert, toList)

pid = ([(2, 3)], 0)

logoot1 = empty ""
    |> insert pid "hey!" 
    |> remove pid "hey!" 
    |> toList

logoot2 = empty ""
    |> remove pid "hey!"
    |> insert pid "hey!"
    |> toList

result = logoot1 == logoot2 -- True
```

Having commutative operations gives us the freedom of sending 
operations to other replicas without caring if they are being 
transmitted through a unreliable and poor connection. We can also
run the same operations in a local replica and have instant updates!

P2P networks can be pretty unreliable, specially when users have
a poor connection (e.g. bad cellular networks).

Apps like Google Docs tend to provide a poor experience for users with bad
connections and not even work offline at all.

With a data structure like Logoot you can build your app with the confidence
that it will work well and be always consistent. ~~Magic~~ Math!

Visit the [API documentation page][docs-url] and take a look at everything this library
offers.

[docs-url]: http://package.elm-lang.org/packages/hugobessaa/elm-logoot/1.2.3/Logoot

## Todo

This project is in constant development and should not be considered stable. I
already have some major bumps planned as I experiment with the API, so beware.

- [ ] Implement `Logoot.Batch`
  - A module full of helpers (`applyBatch`, `decodeBatch`, `encodeBatch`, …)
    and types (`Batch`, `Operation`, …) to make it easier to users to send
    their changes to another replicas
- [x] Make `Logoot` value type agnostic
  - Just like you can do with a `List`, I want to be able to store any value
    type inside a `Logoot`. The type would be something along `Logoot a`. Right
    now it only knows how to hold `String`.
- [ ] Fix `Pid` type, making it impossible to generate invalid pids
  - `([(-1, -1)], -1)` and `([], 0)` are invalid pids. `Positions` is really a
    `Cons Position` not `List Position`. `Line` is an `Int` between 0 and
    32000 (exclusive).
- [ ] Write example apps!

## Contribute!

There are a lot of missing pieces here, help us sending PRs to the GitHub [repository]!

[repository]: https://github.com/hugobessaa/elm-logoot

