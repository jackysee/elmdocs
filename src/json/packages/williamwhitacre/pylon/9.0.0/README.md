# Pylon

## Update (30APR2016)

Pylon is currently growing rapidly and organically to facilitate completion of our project on time.
Some good, bad, and ugly is present, but overall the foundation is much better and cleaner than
Scaffold was. Since our minimum viable product development phase is nearly over with, Pylon will
be getting a much needed major overhaul over the next full two months.

The new version of the API will be more completely founded on the `App.chain` pattern that is really
wonderful for dispatching side effects in a fluent way and do away with the Group, Data, and
Resource types altogether. A new API has been designed that treats the database connection as a
single active JSON record maintained by a data structure designed in the following way:

1. Each instance of `DB.Record` contains a version history that spans the time between the last
external update and now.
2. The root of the application contains the master copy and passes references to it to the other
components.
3. A simple path traversal stack with `push`, `pop`, and `replace` functions, `open` (open current
path), `openr` (open current path recursively), `close` (close current path), as primitives for
manipulating the active record's scope and subscriptions.
4. When a sub component's instance is changed by pending writes, open/close operations, or deferred
reads, a single task is dispatched that is guaranteed to obey all of the constraints specified during
manipulation of the `Record`.

More news on the development of this system later. There should be a single commit by mid to late May.

**NOTE :** Pylon.Tree has been removed. 

## Initial Commit Readme

### The Production Version of Scaffold

The big experiment, [Scaffold](https://github.com/williamwhitacre/scaffold), has been pruned to it's
most useful essentials, and the database API has been exposed. This takes only the best
architectural features from Scaffold, leaving a much more workable interface with very little bloat
to work through. Scaffold lives through Pylon, the refined and heavily pruned addition. Pylon does
not suffer from the same horrible type bloat and takes much better advantage of the Elm Architecture
overall.

~Examples will be coming very soon, within two weeks. Enjoy!~

_TODO : Write a variation of the
[Elm Architecture Tutorial](https://github.com/evancz/elm-architecture-tutorial) which gently
introduces the many helpers provided and culminates in building a simple but fully fledged
application against Firebase using Pylon and ElmFire (with deepest appreciation and love to
[Thomas Weiser](https://github.com/ThomasWeiser) for his amazing work)._
