# lovasoa/elm-rolling-list

## Circular buffer

A *Rolling List* is a list with a finite number of elements that can be inifintely
iterated over.

```elm
    >>> import RollingList
    >>> rl = RollingList.fromList [1,2]
    >>> RollingList.current rl
    Just 1
    >>> rolled = RollingList.roll rl
    >>> RollingList.current rolled
    Just 2
    >>> rolledTwice = RollingList.roll rolled
    >>> RollingList.current rolledTwice
    Just 1
```

## test

Just run `npm install && npm test`
