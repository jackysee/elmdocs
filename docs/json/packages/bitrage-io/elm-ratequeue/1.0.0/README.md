# Rate-Limited Queues in Elm

[![GitHub issues](https://img.shields.io/github/issues/bitrage-io/elm-ratequeue.svg?style=flat-square)](https://github.com/bitrage-io/elm-ratequeue/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/bitrage-io/elm-ratequeue.svg?style=flat-square)](https://github.com/bitrage-io/elm-ratequeue/pulls)

> Rate-limited queues for arbitrary data types

`elm-ratequeue` provides rate-limited queues for arbitrary data types. Currently
the primary use-case for this is to release batched HTTP requests at regular
intervals to avoid hitting rate limit caps from third-party APIs.

## Install

```sh
elm-package install bitrage-io/elm-ratequeue
```

## Usage

```elm
import Dict exposing (Dict)
import RateQueue exposing (RateQueue)
import Time

-- Create a new queue
emptyQueue : RateQueue String
emptyQueue =
    RateQueue.new Time.second

-- Add some items to the queue
queueWithItems : RateQueue String
queueWithItems =
    RateQueue.enqueue ["a", "b", "c"] emptyQueue

-- Release something from the queue
queueAndReleasedItem : ( RateQueue String, Maybe String )
queueAndReleasedItem =
    RateQueue.release 0 queueWithItems

-- Add some items to a queue in a dictionary
queueDict : Dict String (RateQueue String)
queueDict =
    RateQueue.enqueueDict Time.second "queue-id" ["a", "b", "c"] Dict.empty

-- Release items from all queues in a dictionary
queueDictAndReleasedItems : (Dict String (RateQueue String), List String)
queueDictAndReleasedItems =
    RateQueue.releaseDict 0 queueDict
```

## Contribute

Feel free to [open an issue](https://github.com/bitrage-io/elm-ratequeue/issues) or submit a pull-request!

## License

[BSD3](https://opensource.org/licenses/BSD-3-Clause)
