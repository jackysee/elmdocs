elm-deque
=========

A deque (the name is pronounced "deck" and is short for "double-ended queue") is a data type for which elements can be efficiently added or removed from either the front or the back.

Deques are perfect when pop and push (or, head and cons) access to both sides of a list is needed. Deques are also used for implementing 
work-stealing job scheduling algorithms: Jobs are distributed over multiple deques, that run in multiple threads. When one thread finishes its deque of jobs, 
it can "steal" (using popBack) jobs from other threads.

Finally, this implementation allows setting a maximum size. This is useful for creating a sliding window over a stream of data. For example, 
this can be used to keep the last 5 values from a subscription, say the last 5 clicks. 

# Example 

```elm
import Deque

example1 = 
    Deque.empty 
        |> Deque.pushFront 4
        |> Deque.pushBack 2
        |> Deque.popFront |> snd 
        |> Deque.popBack  |> fst
        -- Just 2

example2 = 
    Deque.fromList [0..9]
        |> setMaxSize (Just 5)
        -- toList would give [ 0, 1, 2, 3, 4 ] 
        |> pushFront 42 
        -- toList would give [ 42, 0, 1, 2, 3 ] 
        |> pushBack -1 
        -- toList would give [ 0, 1, 2, 3, -1 ] 
        |> setMaxSize Nothing 
        |> pushFront 73
        -- toList would give [ 73, 0, 1, 2, 3, -1 ] 
```
