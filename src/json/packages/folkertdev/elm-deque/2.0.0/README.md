elm-deque
=========

A deque (the name is pronounced "deck" and is short for "double-ended queue") is a data type that allows elements to be efficiently added or removed from either the front or the back.

Deques are perfect when pop and push (or, head and cons) access to both sides of a list is needed. Deques are also used for implementing 
work-stealing job scheduling algorithms: Jobs are distributed over multiple deques, that run in multiple threads. When one thread finishes its deque of jobs, 
it can "steal" (using popBack) jobs from other threads.

Finally, the BoundedDeque additionally allows setting a maximum size. This is useful for creating a sliding window over a stream of data. For example, 
to keep the last 5 values from a subscription, say the last 5 clicks. 

# Example 

```elm
import Deque

example1 = 
    Deque.empty 
        |> Deque.pushFront 4
        |> Deque.pushBack 2
        |> Deque.popFront |> Tuple.second 
        |> Deque.popBack  |> Tuple.first
        -- Just 2

example2 = 
    BoundedDeque.fromList 10 (List.range 0 9)
        |> BoundedDeque.resize (\_ -> 5) 
        -- toList would give [ 0, 1, 2, 3, 4 ] 
        |> BoundedDeque.pushFront 42 
        -- toList would give [ 42, 0, 1, 2, 3 ] 
        |> BoundedDeque.pushBack -1 
        -- toList would give [ 0, 1, 2, 3, -1 ] 
        |> BoundedDeque.toDeque
        |> Deque.pushFront 73
        -- toList would give [ 73, 0, 1, 2, 3, -1 ] 
```
