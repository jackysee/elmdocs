This module makes it possible to integrate Elm with real-time storage services like [Firebase](http://firebase.com) or [Parse](http://parse.com).

The typical usage is:

1. Send cache update commands from your storage listeners to a mailbox of `Update`s.
1. Define a `Cache` based on the update feed which will store all remote values.
1. Build your model from the cache using `load` and `loadRaw`.
1. Collect the URLs of every reference in your model (including those which are not yet in the cache) and observe them in your storage.

For an example application, see: https://github.com/thSoft/RemoteModel
